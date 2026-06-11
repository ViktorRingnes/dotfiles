; extends

(match_arm) @matcharm.outer
(match_arm
  value: (_) @matcharm.inner)

(unsafe_block) @unsafe.outer
(unsafe_block
  (block) @unsafe.inner)
