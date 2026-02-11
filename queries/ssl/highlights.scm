; Tree-sitter highlight queries for SSL (Fallout Script)

; ============================================================
; Keywords
; ============================================================

[
  "procedure"
  "begin"
  "end"
  "variable"
  "import"
  "export"
  "include"
] @keyword

[
  "if"
  "then"
  "else"
  "while"
  "do"
  "for"
  "foreach"
  "in"
  "switch"
  "case"
  "default"
] @keyword.conditional

[
  "call"
  "return"
  "break"
  "continue"
] @keyword.control

[
  "critical"
  "pure"
  "inline"
  "when"
] @keyword.modifier

; ============================================================
; Operators
; ============================================================

[
  ":="
  "="
  "+="
  "-="
  "*="
  "/="
] @operator

[
  "+"
  "-"
  "*"
  "/"
  "%"
  "^"
  "=="
  "!="
  "<"
  ">"
  "<="
  ">="
  "++"
  "--"
] @operator

[
  "and"
  "or"
  "not"
  "andalso"
  "orelse"
  "bwand"
  "bwor"
  "bwxor"
  "bwnot"
  "floor"
  "div"
] @keyword.operator

"@" @operator

; ============================================================
; Literals
; ============================================================

(number) @number
(float) @number.float
(string) @string
(char_literal) @character
(boolean) @boolean

; ============================================================
; Identifiers and Definitions
; ============================================================

(procedure_definition
  name: (identifier) @function.definition)

(parameter
  name: (identifier) @variable.parameter)

(variable_declarator
  name: (identifier) @variable)

(extern_variable
  name: (identifier) @variable)

(extern_procedure
  name: (identifier) @function)

; Function calls
(call_expression
  function: (identifier) @function.call)

(call_statement
  function: (identifier) @function.call)

; Subscript / member access
(member_expression
  property: (identifier) @property)

; Stringify
(stringify_expression
  (identifier) @function)

; foreach element variables
(foreach_statement
  element: (identifier) @variable)
(foreach_statement
  element2: (identifier) @variable)

; ============================================================
; Comments and Preprocessor
; ============================================================

(line_comment) @comment
(block_comment) @comment
(preproc_directive) @keyword.directive

; ============================================================
; Punctuation
; ============================================================

["(" ")"] @punctuation.bracket
["[" "]"] @punctuation.bracket
["{" "}"] @punctuation.bracket

[";" "," ":" "."] @punctuation.delimiter

; ============================================================
; Built-in functions (statement form)
; Highlighted via identifier name matching.
; ============================================================

; Core statement keywords (no arguments)
((identifier) @keyword.builtin
  (#any-of? @keyword.builtin
    "noop"
    "exit"
    "detach"
    "cancelall"
    "startcritical"
    "endcritical"
    ))

; Event/call-like keywords
((identifier) @keyword.builtin
  (#any-of? @keyword.builtin
    "spawn"
    "fork"
    "exec"
    "callstart"
    "wait"
    "cancel"
    ))

; ============================================================
; Common Fallout scripting functions recognized by the compiler.
; ============================================================

(call_expression
  function: (identifier) @function.builtin
  (#any-of? @function.builtin
    ; --- Display & UI ---
    "display_msg"
    "debug_msg"
    "float_msg"
    "print"
    "format"
    "printrect"
    "setfont"
    "settextflags"
    "settextcolor"
    "sethighlightcolor"
    "gotoxy"
    "createwin"
    "deletewin"
    "selectwin"
    "resizewin"
    "scalewin"
    "showwin"
    "fillwin"
    "fillrect"
    "fillwin3x3"
    "display"
    "displayraw"
    "displaygfx"
    "loadpalettetable"
    "fadein"
    "fadeout"
    "hidemouse"
    "showmouse"
    "mouseshape"
    "refreshmouse"
    "setglobalmousefunc"

    ; --- Movies ---
    "playmovie"
    "playmoviealpha"
    "playmoviealpharect"
    "playmovierect"
    "movieflags"
    "stopmovie"
    "play_gmovie"

    ; --- Sound ---
    "soundplay"
    "soundpause"
    "soundresume"
    "soundstop"
    "soundrewind"
    "sounddelete"
    "play_sfx"

    ; --- Buttons & Regions ---
    "addbutton"
    "addbuttontext"
    "addbuttongfx"
    "addbuttonproc"
    "addbuttonflag"
    "addbuttonrightproc"
    "deletebutton"
    "addregion"
    "addregionproc"
    "addregionflag"
    "addregionrightproc"
    "deleteregion"
    "activateregion"
    "checkregion"
    "addkey"
    "deletekey"

    ; --- Dialog ---
    "gsay_start"
    "gsay_end"
    "gsay_reply"
    "gsay_option"
    "gsay_message"
    "giq_option"
    "start_gdialog"
    "end_dialogue"
    "dialogue_reaction"
    "saystart"
    "saystartpos"
    "sayend"
    "sayquit"
    "sayreply"
    "saygotoreply"
    "sayreplytitle"
    "sayoption"
    "saymessage"
    "sayreplyflags"
    "sayoptionflags"
    "sayreplywindow"
    "sayoptionwindow"
    "sayborder"
    "sayscrollup"
    "sayscrolldown"
    "saysetspacing"
    "sayoptioncolor"
    "sayreplycolor"
    "sayrestart"
    "saygetlastpos"
    "saymessagetimeout"

    ; --- Object ---
    "obj_pid"
    "obj_name"
    "obj_type"
    "obj_item_subtype"
    "obj_art_fid"
    "obj_on_screen"
    "obj_is_carrying_obj_pid"
    "obj_carrying_pid_obj"
    "obj_is_locked"
    "obj_lock"
    "obj_unlock"
    "obj_is_open"
    "obj_open"
    "obj_close"
    "obj_can_see_obj"
    "obj_can_hear_obj"
    "obj_set_light_level"
    "set_obj_visibility"
    "obj_being_used_with"
    "obj_is_carrying_obj"
    "obj_blocking_at"

    ; --- Critter ---
    "get_critter_stat"
    "set_critter_stat"
    "critter_heal"
    "critter_dmg"
    "critter_state"
    "critter_injure"
    "critter_attempt_placement"
    "critter_add_trait"
    "critter_rm_trait"
    "critter_inven_obj"
    "critter_mod_skill"
    "critter_is_fleeing"
    "critter_set_flee_state"
    "critter_stop_attacking"
    "kill_critter"
    "kill_critter_type"
    "get_pc_stat"

    ; --- Tile ---
    "tile_num"
    "tile_num_in_direction"
    "tile_distance"
    "tile_distance_objs"
    "tile_is_visible"
    "tile_contains_pid_obj"
    "tile_contains_obj_pid"
    "tile_in_tile_rect"
    "tile_pid"
    "tile_under_cursor"
    "tile_light"
    "tile_get_objects"

    ; --- Inventory ---
    "add_obj_to_inven"
    "rm_obj_from_inven"
    "add_mult_objs_to_inven"
    "rm_mult_objs_from_inven"
    "move_obj_inven_to_obj"
    "wield_obj_critter"
    "inven_unwield"
    "inven_cmds"
    "pickup_obj"
    "drop_obj"
    "use_obj"
    "use_obj_on_obj"

    ; --- Combat ---
    "attack"
    "attack_complex"
    "attack_setup"
    "combat_is_initialized"
    "terminate_combat"
    "block_combat"
    "get_attack_type"

    ; --- Map & World ---
    "cur_map_index"
    "load_map"
    "set_map_start"
    "override_map_start"
    "set_exit_grids"
    "wm_area_set_pos"
    "world_map"
    "set_map_music"
    "in_world_map"
    "set_world_map_pos"
    "get_world_map_x_pos"
    "get_world_map_y_pos"
    "force_encounter"
    "force_encounter_with_flags"
    "mark_area_known"
    "days_since_visited"

    ; --- Game state ---
    "game_time"
    "game_time_in_seconds"
    "game_time_hour"
    "game_time_advance"
    "game_ticks"
    "game_ui_disable"
    "game_ui_enable"
    "game_ui_is_disabled"
    "get_game_mode"
    "get_month"
    "get_day"
    "get_year"
    "difficulty_level"
    "combat_difficulty"
    "gfade_out"
    "gfade_in"

    ; --- Variables ---
    "local_var"
    "set_local_var"
    "map_var"
    "set_map_var"
    "global_var"
    "set_global_var"
    "set_sfall_global"
    "get_sfall_global_int"
    "get_sfall_global_float"

    ; --- Special objects ---
    "self_obj"
    "source_obj"
    "target_obj"
    "dude_obj"
    "fixed_param"
    "script_action"
    "action_being_used"

    ; --- Misc ---
    "random"
    "elevation"
    "anim_busy"
    "add_timer_event"
    "rm_timer_event"
    "destroy_object"
    "destroy_mult_objs"
    "create_object_sid"
    "has_trait"
    "has_skill"
    "using_skill"
    "roll_vs_skill"
    "skill_contest"
    "do_check"
    "is_success"
    "is_critical"
    "how_much"
    "give_exp_points"
    "scr_return"
    "script_overrides"
    "radiation_inc"
    "radiation_dec"
    "poison"
    "get_poison"
    "party_add"
    "party_remove"
    "party_member_obj"
    "get_party_members"
    "item_caps_total"
    "item_caps_adjust"
    "proto_data"
    "get_proto_data"
    "set_proto_data"
    "message_str"
    "message_str_game"
    "metarule"
    "metarule3"
    "set_light_level"
    "get_light_level"
    "make_daytime"
    "move_to"
    "rotation_to_tile"
    "endgame_slideshow"
    "endgame_movie"
    "running_burning_guy"
    "gdialog_set_barter_mod"
    "gdialog_mod_barter"
    "selectfilelist"
    "tokenize"
    "setoneoptpause"
    "explosion"
    "jam_lock"
    "art_anim"
    "art_exists"
    "sfx_build_open_name"
    "sfx_build_char_name"
    "sfx_build_ambient_name"
    "sfx_build_interface_name"
    "sfx_build_item_name"
    "sfx_build_weapon_name"
    "sfx_build_scenery_name"
    "make_straight_path"
    "path_find"
    "sneak_success"
    "set_map_time_multi"
    "refresh_pc_art"
    "create_spatial"

    ; --- Animation ---
    "animate_stand_obj"
    "animate_stand_reverse_obj"
    "animate_move_obj_to_tile"
    "anim"
    "anim_action_frame"
    "reg_anim_func"
    "reg_anim_animate"
    "reg_anim_animate_reverse"
    "reg_anim_animate_forever"
    "reg_anim_obj_move_to_obj"
    "reg_anim_obj_run_to_obj"
    "reg_anim_obj_move_to_tile"
    "reg_anim_obj_run_to_tile"
    "reg_anim_play_sfx"
    "reg_anim_destroy"
    "reg_anim_animate_and_hide"
    "reg_anim_combat_check"
    "reg_anim_light"
    "reg_anim_change_fid"
    "reg_anim_take_out"
    "reg_anim_turn_towards"
    "reg_anim_callback"

    ; --- Named events ---
    "addnamedevent"
    "addnamedhandler"
    "clearnamed"
    "signalnamed"

    ; --- sfall: Arrays ---
    "create_array"
    "set_array"
    "get_array"
    "free_array"
    "len_array"
    "resize_array"
    "temp_array"
    "fix_array"
    "scan_array"
    "save_array"
    "load_array"
    "get_array_key"
    "stack_array"
    "list_as_array"
    "list_begin"
    "list_next"
    "list_end"

    ; --- sfall: String ---
    "string_split"
    "substr"
    "strlen"
    "sprintf"
    "ord"
    "atoi"
    "atof"
    "typeof"

    ; --- sfall: Math ---
    "sqrt"
    "abs"
    "sin"
    "cos"
    "tan"
    "atan"
    "log"
    "exp"
    "ceil"
    "round"

    ; --- sfall: Memory ---
    "read_byte"
    "read_short"
    "read_int"
    "read_string"
    "write_byte"
    "write_short"
    "write_int"
    "write_string"

    ; --- sfall: Hooks ---
    "register_hook"
    "register_hook_proc"
    "register_hook_proc_spec"
    "init_hook"
    "get_sfall_arg"
    "get_sfall_args"
    "set_sfall_arg"
    "set_sfall_return"

    ; --- sfall: Input ---
    "key_pressed"
    "tap_key"
    "get_mouse_x"
    "get_mouse_y"
    "get_mouse_buttons"
    "get_window_under_mouse"
    "get_screen_width"
    "get_screen_height"
    "input_funcs_available"

    ; --- sfall: Shaders ---
    "load_shader"
    "free_shader"
    "activate_shader"
    "deactivate_shader"
    "set_shader_int"
    "set_shader_float"
    "set_shader_vector"
    "get_shader_version"
    "set_shader_mode"
    "get_shader_texture"
    "set_shader_texture"
    "graphics_funcs_available"
    "force_graphics_refresh"

    ; --- sfall: Game config ---
    "get_ini_setting"
    "get_ini_string"
    "modified_ini"
    "game_loaded"
    "set_global_script_repeat"
    "set_global_script_type"
    "available_global_script_types"
    "stop_game"
    "resume_game"
    "create_message_window"
    "set_self"
    "set_palette"
    "remove_script"
    "set_script"
    "get_script"
    "get_uptime"

    ; --- sfall: Stat/Skill mods ---
    "set_pc_base_stat"
    "set_pc_extra_stat"
    "get_pc_base_stat"
    "get_pc_extra_stat"
    "set_critter_base_stat"
    "set_critter_extra_stat"
    "get_critter_base_stat"
    "get_critter_extra_stat"
    "get_critter_ap"
    "set_critter_ap"
    "set_critter_burst_disable"
    "get_weapon_ammo_pid"
    "set_weapon_ammo_pid"
    "get_weapon_ammo_count"
    "set_weapon_ammo_count"
    "get_active_hand"
    "toggle_active_hand"
    "remove_trait"
    "set_critter_skill_points"
    "get_critter_skill_points"
    "set_available_skill_points"
    "get_available_skill_points"
    "mod_skill_points_per_level"
    "set_skill_max"
    "set_stat_max"
    "set_stat_min"
    "set_pc_stat_max"
    "set_pc_stat_min"
    "set_npc_stat_max"
    "set_npc_stat_min"
    "get_npc_level"
    "inc_npc_level"
    "set_hit_chance_max"
    "set_pickpocket_max"
    "set_critter_hit_chance_mod"
    "set_base_hit_chance_mod"
    "set_critter_skill_mod"
    "set_base_skill_mod"
    "set_critter_pickpocket_mod"
    "set_base_pickpocket_mod"
    "get_kill_counter"
    "mod_kill_counter"
    "get_last_attacker"
    "get_last_target"

    ; --- sfall: Perk mods ---
    "set_perk_image"
    "set_perk_ranks"
    "set_perk_level"
    "set_perk_stat"
    "set_perk_stat_mag"
    "set_perk_skill1"
    "set_perk_skill1_mag"
    "set_perk_type"
    "set_perk_skill2"
    "set_perk_skill2_mag"
    "set_perk_str"
    "set_perk_per"
    "set_perk_end"
    "set_perk_chr"
    "set_perk_int"
    "set_perk_agl"
    "set_perk_lck"
    "set_perk_name"
    "set_perk_desc"
    "set_perk_freq"
    "set_perk_level_mod"
    "get_perk_owed"
    "set_perk_owed"
    "get_perk_available"
    "set_fake_perk"
    "set_fake_trait"
    "set_selectable_perk"
    "set_perkbox_title"
    "hide_real_perks"
    "show_real_perks"
    "has_fake_perk"
    "has_fake_trait"
    "perk_add_mode"
    "clear_selectable_perks"

    ; --- sfall: Knockback ---
    "set_weapon_knockback"
    "set_target_knockback"
    "set_attacker_knockback"
    "remove_weapon_knockback"
    "remove_target_knockback"
    "remove_attacker_knockback"

    ; --- sfall: Combat mods ---
    "set_xp_mod"
    "set_pyromaniac_mod"
    "apply_heaveho_fix"
    "set_swiftlearner_mod"
    "set_hp_level_mod"
    "set_inven_ap_cost"
    "get_barter_mod"
    "set_unspent_ap_bonus"
    "get_unspent_ap_bonus"
    "set_unspent_ap_ebonus"
    "get_unspent_ap_ebonus"
    "force_aimed_shots"
    "disable_aimed_shots"
    "get_bodypart_hit_modifier"
    "set_bodypart_hit_modifier"
    "set_critical_table"
    "get_critical_table"
    "reset_critical_table"
    "explosions_metarule"
    "mark_movie_played"

    ; --- sfall: Appearance ---
    "set_dm_model"
    "set_df_model"
    "set_movie_path"
    "set_pipboy_available"
    "hero_select_win"
    "set_hero_race"
    "set_hero_style"
    "nb_create_char"

    ; --- sfall: Filesystem ---
    "fs_create"
    "fs_copy"
    "fs_find"
    "fs_write_byte"
    "fs_write_short"
    "fs_write_int"
    "fs_write_float"
    "fs_write_string"
    "fs_write_bstring"
    "fs_read_byte"
    "fs_read_short"
    "fs_read_int"
    "fs_read_float"
    "fs_delete"
    "fs_size"
    "fs_pos"
    "fs_seek"
    "fs_resize"

    ; --- sfall: Call offset ---
    "call_offset_v0"
    "call_offset_v1"
    "call_offset_v2"
    "call_offset_v3"
    "call_offset_v4"
    "call_offset_r0"
    "call_offset_r1"
    "call_offset_r2"
    "call_offset_r3"
    "call_offset_r4"

    ; --- sfall: Interface tags ---
    "show_iface_tag"
    "hide_iface_tag"
    "is_iface_tag_active"

    ; --- sfall: Sound ---
    "play_sfall_sound"
    "stop_sfall_sound"
    "eax_available"
    "set_eax_environment"

    ; --- sfall: Misc ---
    "set_car_current_town"
    "set_map_time_multi"
    "sfall_ver_major"
    "sfall_ver_minor"
    "sfall_ver_build"

    ; --- sfall: Universal metarule opcodes ---
    "sfall_func0"
    "sfall_func1"
    "sfall_func2"
    "sfall_func3"
    "sfall_func4"
    "sfall_func5"
    "sfall_func6"
    "sfall_func7"
    "sfall_func8"
    ))
