; Scope definitions for SSL

; Procedure body is a scope
(procedure_definition
  (block) @local.scope)

; Block creates a scope (for locally declared variables)
(block) @local.scope

; Variable declarations define names
(variable_declarator
  name: (identifier) @local.definition)

; Parameters define names
(parameter
  name: (identifier) @local.definition)

; foreach element variables
(foreach_statement
  element: (identifier) @local.definition)
(foreach_statement
  element2: (identifier) @local.definition)

; References
(identifier) @local.reference
