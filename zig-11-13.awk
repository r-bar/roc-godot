BEGIN{ FS=":" }

/error: local variable is never mutated/{
  cmd=sprintf("sed -i '%ss/var/const/' %s;\n", $2, $1)
  printf "echo \"%s\"\n", cmd
  printf "%s\n", cmd
} 

/error: 'comptime const' is redundant/{
  cmd=sprintf("sed -i '%ss/comptime const/const/' %s;\n", $2, $1)
  printf "echo \"%s\"\n", cmd
  printf "%s\n", cmd
}

/error: invalid builtin function: '@fabs'/{
  cmd=sprintf("sed -i '%ss/@fabs/@abs/' %s;\n", $2, $1)
  printf "echo \"%s\"\n", cmd
  printf "%s\n", cmd
}

/error: root struct of file 'math' has no member named 'absInt'/{
  cmd=sprintf("sed -i '%ss/math.absInt/@abs/' %s;\n", $2, $1)
  printf "echo \"%s\"\n", cmd
  printf "%s\n", cmd
}

/error: no field named 'Strong' in enum 'builtin.GlobalLinkage'/{
  cmd=sprintf("sed -i '%ss/\\.Strong/.strong/' %s;\n", $2, $1)
  printf "echo \"%s\"\n", cmd
  printf "%s\n", cmd
}

/error: root struct of file 'mem' has no member named 'copy'/{
  cmd=sprintf("sed -i '%ss/(std\\.)?(mem\\.)copy/@memcpy/' %s;\n", $2, $1)
  printf "echo \"%s\"\n", cmd
  printf "%s\n", cmd
}

#{print $0}
