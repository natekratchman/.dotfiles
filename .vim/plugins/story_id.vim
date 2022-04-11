" inserts SID into your commit message,
" assuming your branch matches the regex: (?<description>\w+)[-_](?<storyid>\w+)
" and the SID begins with 'PROD'
function! InsertStoryId()
  let sid_command = "mi"                           " mark current position

  let sid_command = sid_command."\/PROD\<CR>"      " move to line with branch name
  let sid_command = sid_command."yE"               " yank the SID
  let sid_command = sid_command."\/^#\<CR>ggn"     " move to first #... line
  let sid_command = sid_command."\:nohls\<CR>"     " clear search highlight
  let sid_command = sid_command."O\<esc>"          " add new line
  let sid_command = sid_command."p"                " insert SID
  let sid_command = sid_command."O\<esc>"          " add new line above SID

  let sid_command = sid_command."`i"               " return to previous position
  let sid_command = sid_command.":delmarks i\<CR>" " delete mark

  exec "normal! ".sid_command
endfunction

command! InsertStoryId :call InsertStoryId()
