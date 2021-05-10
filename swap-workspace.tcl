#!/usr/bin/env jimsh

proc moveWorkspace {ws1 ws2} {
  set cmd1 "rename workspace $ws1 to temporary"
  set cmd2 "rename workspace $ws2 to $ws1"
  set cmd3 "rename workspace temporary to $ws2"
  exec i3-msg "$cmd1;$cmd2;$cmd3"
}

proc getCurrentWorkspace {} {
  exec sh -c {
    i3-msg -t get_workspaces |
    jq -r '.[] | select(.focused==true).name'
  }
}

proc main {direction} {
  set MIN_WS 1
  set MAX_WS 9
  set ws1 [getCurrentWorkspace]
  set ws2 [expr {$direction eq "left" ? [- $ws1 1] : [+ $ws1 1]}]
  if {
    $ws1 == $ws2 ||
    $ws1 > $MAX_WS || $ws2 > $MAX_WS ||
    $ws1 < $MIN_WS || $ws2 < $MIN_WS
  } return
  moveWorkspace $ws1 $ws2
}

main [lindex $argv 0]
