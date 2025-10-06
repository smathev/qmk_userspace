#pragma once

#include QMK_KEYBOARD_H

// Explicit extern declaration for introspection system with correct size
extern combo_t key_combos[COMBO_COUNT];

enum combo_events {
  UNDO,
  ENT,
  TAB,
  CUT,
  COPY,
  PASTE,
  DEL,
  BCKSP,
  CTTB,
  ESC,
  SVFILE,
  SRCH,
  CTCL,
  CANCEL,
  CTROP,
  FFIVE,
  RESET_KEYBOARD
};

extern combo_t key_combos[];
