/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

/**
 * Tree-sitter grammar for SSL (Star-Trek Scripting Language)
 * Used by Fallout 1/2 and sfall for game scripting.
 */

/** @param {RuleOrLiteral} rule */
function commaSep1(rule) {
  return seq(rule, repeat(seq(',', rule)));
}

/** @param {RuleOrLiteral} rule */
function commaSep(rule) {
  return optional(commaSep1(rule));
}

const PREC = {
  ASSIGN: 1,
  TERNARY: 2,
  OR: 3,
  AND: 4,
  COMPARE: 5,
  ADD: 6,
  MULTIPLY: 7,
  UNARY: 8,
  POSTFIX: 9,
  CALL: 10,
  MEMBER: 11,
};

export default grammar({
  name: 'ssl',

  extras: $ => [
    /\s/,
    $.line_comment,
    $.block_comment,
    $.preproc_directive,
  ],

  word: $ => $.identifier,

  supertypes: $ => [
    $._expression,
  ],

  conflicts: $ => [
    [$._foreach_header],
  ],

  rules: {
    source_file: $ => repeat($._top_level),

    _top_level: $ => choice(
      $.procedure_definition,
      $.variable_declaration,
      $.import_statement,
      $.export_statement,
      $.include_directive,
    ),

    // ============================================================
    // Comments and Preprocessor
    // ============================================================

    line_comment: $ => token(seq('//', /[^\n]*/)),

    block_comment: $ => token(seq(
      '/*',
      /[^*]*\*+([^/*][^*]*\*+)*/,
      '/',
    )),

    preproc_directive: $ => token(seq('#', /[^\n]*/)),

    // ============================================================
    // Procedure Definition
    // ============================================================

    procedure_definition: $ => seq(
      repeat(choice('critical', 'pure', 'inline')),
      'procedure',
      field('name', $.identifier),
      optional($.parameter_list),
      choice(
        seq(
          optional(choice(
            seq('in', field('time', $._expression)),
            seq('when', field('condition', $._expression)),
          )),
          $.block,
        ),
        ';', // forward declaration
      ),
    ),

    parameter_list: $ => seq(
      '(',
      commaSep($.parameter),
      ')',
    ),

    parameter: $ => seq(
      'variable',
      field('name', $.identifier),
      optional(seq(choice(':=', '='), field('default', $._expression))),
    ),

    // ============================================================
    // Variable Declaration
    // ============================================================

    variable_declaration: $ => seq(
      'variable',
      choice(
        seq(
          'begin',
          repeat(seq(commaSep1($.variable_declarator), ';')),
          'end',
        ),
        seq(commaSep1($.variable_declarator), ';'),
      ),
    ),

    variable_declarator: $ => seq(
      field('name', $.identifier),
      optional(choice(
        seq('[', $._expression, optional(seq(',', $._expression)), ']'),
        seq(choice(':=', '='), $._expression),
      )),
    ),

    // ============================================================
    // Import / Export
    // ============================================================

    import_statement: $ => seq(
      'import',
      $._extern_block,
    ),

    export_statement: $ => seq(
      'export',
      $._extern_block,
    ),

    _extern_block: $ => choice(
      seq('variable', choice(
        seq('begin', repeat($.extern_variable), 'end'),
        $.extern_variable,
      )),
      seq('procedure', choice(
        seq('begin', repeat($.extern_procedure), 'end'),
        $.extern_procedure,
      )),
    ),

    extern_variable: $ => seq(
      field('name', $.identifier),
      optional(seq(choice(':=', '='), $._expression)),
      ';',
    ),

    extern_procedure: $ => seq(
      field('name', $.identifier),
      optional($.parameter_list),
      ';',
    ),

    // ============================================================
    // Include
    // ============================================================

    include_directive: $ => seq('include', field('path', $.string)),

    // ============================================================
    // Blocks and Statements
    // ============================================================

    block: $ => seq('begin', repeat($._statement), 'end'),

    _statement: $ => choice(
      $.block,
      $.if_statement,
      $.while_statement,
      $.for_statement,
      $.foreach_statement,
      $.switch_statement,
      $.variable_declaration,
      $.call_statement,
      $.return_statement,
      $.break_statement,
      $.continue_statement,
      $.expression_statement,
    ),

    if_statement: $ => prec.right(seq(
      'if',
      field('condition', $._expression),
      'then',
      field('consequence', $._statement),
      optional(field('alternative', $.else_clause)),
    )),

    else_clause: $ => seq('else', $._statement),

    while_statement: $ => seq(
      'while',
      field('condition', $._expression),
      'do',
      field('body', $._statement),
    ),

    // for (init; condition; update) body
    // for init; condition; update; body
    //
    // In the original parser, parseStatement (which consumes ';') is called
    // for init. So the first ';' is consumed by the init statement. Then
    // condition is parsed, then explicit ';', then update (no ';' in paren
    // form, explicit ';' in non-paren form).
    for_statement: $ => seq(
      'for',
      choice(
        seq(
          '(',
          field('init', $._expression),
          ';',
          field('condition', $._expression),
          ';',
          field('update', $._expression),
          ')',
        ),
        seq(
          field('init', $._expression),
          ';',
          field('condition', $._expression),
          ';',
          field('update', $._expression),
          ';',
        ),
      ),
      field('body', $._statement),
    ),

    // foreach ([variable] element [: element2] in collection [while cond]) body
    foreach_statement: $ => seq(
      'foreach',
      choice(
        seq('(', $._foreach_header, ')'),
        $._foreach_header,
      ),
      field('body', $._statement),
    ),

    _foreach_header: $ => seq(
      optional('variable'),
      field('element', $.identifier),
      optional(seq(':', field('element2', $.identifier))),
      'in',
      field('collection', $._expression),
      optional(seq('while', field('while_condition', $._expression))),
    ),

    // switch value begin case val: stmts... [default: stmts...] end
    switch_statement: $ => seq(
      'switch',
      field('value', $._expression),
      'begin',
      repeat($.case_clause),
      optional($.default_clause),
      'end',
    ),

    case_clause: $ => seq(
      'case',
      field('value', $._expression),
      ':',
      repeat($._statement),
    ),

    default_clause: $ => seq(
      'default',
      ':',
      repeat($._statement),
    ),

    // call name[(args)] [in time | when condition];
    call_statement: $ => seq(
      'call',
      field('function', choice($.identifier, $.string)),
      optional($.argument_list),
      optional(choice(
        seq('in', field('time', $._expression)),
        seq('when', field('condition', $._expression)),
      )),
      ';',
    ),

    return_statement: $ => seq(
      'return',
      optional($._expression),
      ';',
    ),

    break_statement: $ => seq('break', ';'),
    continue_statement: $ => seq('continue', ';'),

    expression_statement: $ => seq($._expression, ';'),

    // ============================================================
    // Expressions
    // ============================================================

    _expression: $ => choice(
      $.assignment_expression,
      $.ternary_expression,
      $.binary_expression,
      $.unary_expression,
      $.update_expression,
      $.call_expression,
      $.subscript_expression,
      $.member_expression,
      $.stringify_expression,
      $.parenthesized_expression,
      $.array_expression,
      $.map_expression,
      $.identifier,
      $.number,
      $.float,
      $.string,
      $.char_literal,
      $.boolean,
    ),

    // x := expr, x = expr, x += expr, etc.
    assignment_expression: $ => prec.right(PREC.ASSIGN, seq(
      field('left', $._expression),
      field('operator', choice(':=', '=', '+=', '-=', '*=', '/=')),
      field('right', $._expression),
    )),

    // Python-style: true_value if (condition) else false_value
    ternary_expression: $ => prec.right(PREC.TERNARY, seq(
      field('consequence', $._expression),
      'if',
      field('condition', $._expression),
      'else',
      field('alternative', $._expression),
    )),

    binary_expression: $ => {
      /** @type {[number, RuleOrLiteral][]} */
      const table = [
        [PREC.OR, choice('or', 'orelse')],
        [PREC.AND, choice('and', 'andalso')],
        [PREC.COMPARE, choice('==', '!=', '<', '>', '<=', '>=')],
        [PREC.ADD, choice('+', '-', 'bwand', 'bwor', 'bwxor')],
        [PREC.MULTIPLY, choice('*', '/', '%', 'div', '^')],
      ];
      return choice(
        ...table.map(([prec_val, op]) =>
          prec.left(prec_val, seq(
            field('left', $._expression),
            field('operator', op),
            field('right', $._expression),
          )),
        ),
      );
    },

    unary_expression: $ => prec(PREC.UNARY, seq(
      field('operator', choice('-', 'not', 'bwnot', 'floor')),
      field('operand', $._expression),
    )),

    // x++, x--
    update_expression: $ => prec(PREC.POSTFIX, seq(
      field('operand', $._expression),
      field('operator', choice('++', '--')),
    )),

    // name(arg1, arg2, ...)
    call_expression: $ => prec(PREC.CALL, seq(
      field('function', $._expression),
      $.argument_list,
    )),

    argument_list: $ => seq('(', commaSep($._expression), ')'),

    // array[index]
    subscript_expression: $ => prec(PREC.MEMBER, seq(
      field('object', $._expression),
      '[',
      field('index', $._expression),
      ']',
    )),

    // object.property (associative array dot access)
    member_expression: $ => prec(PREC.MEMBER, seq(
      field('object', $._expression),
      '.',
      field('property', $.identifier),
    )),

    // @procedure_name (stringify operator)
    stringify_expression: $ => seq('@', $.identifier),

    parenthesized_expression: $ => seq('(', $._expression, ')'),

    // [elem1, elem2, ...]
    array_expression: $ => seq('[', commaSep($._expression), ']'),

    // {key1: val1, key2: val2, ...}
    map_expression: $ => seq(
      '{',
      commaSep($.map_entry),
      '}',
    ),

    map_entry: $ => seq(
      field('key', $._expression),
      ':',
      field('value', $._expression),
    ),

    // ============================================================
    // Literals and Identifiers
    // ============================================================

    identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*/,

    number: $ => token(choice(
      /0[xX][0-9a-fA-F]+/,
      /[0-9]+/,
    )),

    float: $ => token(/[0-9]+\.[0-9]*/),

    string: $ => choice(
      $._regular_string,
      $._verbatim_string,
    ),

    _regular_string: $ => token(seq(
      '"',
      repeat(choice(
        /[^"\\]/,
        /\\./,
      )),
      '"',
    )),

    _verbatim_string: $ => token(seq(
      '@"',
      repeat(/[^"]/),
      '"',
    )),

    // Character literal: 'a', '\n', '\012'
    char_literal: $ => token(seq(
      "'",
      choice(
        /[^'\\]/,
        /\\./,
        /\\[0-7]{2,3}/,
      ),
      "'",
    )),

    boolean: $ => choice('true', 'false'),
  },
});
