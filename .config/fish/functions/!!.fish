function !! --description "Run the last command"
  if test (count $argv) -ge 1
    set cmd $history[1]" $argv"
  else
    set cmd $history[1]
  end
  eval $cmd
end
