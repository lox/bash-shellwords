#!/bin/bash
set -euo pipefail

tokenize_shell_string() {
  local input="$1"
  local token=''
  local escape=''
  local quote=''
  local quote_idx=''

  # Process the input character by character
  for (( i=0 ; i<=${#input} ; i++ )) ; do
    c=${input:i:1}
    # printf '%-2q [escape=%q] [quote=%q] [%q]\n' "$c" "$escape" "$quote" "$token"
    # Handle an escaped character
    if [[ -n "$escape" ]] ; then
      token+="$c"
      escape=''
    # Handles an unescaped backslash, denoting that the next char is escaped
    # Note that single quotes don't support escaping internally
    elif [[ "$c" == \\ ]] && [[ "$quote" != "'" ]] ; then
      escape="$c"
    # Handle open quotes
    elif [[ "$c" =~ [\"|\'] ]] && [[ -z "$quote" ]]; then
      quote="$c"
      quote_idx=$i
    # Handle matching closed quotes
    elif [[ -n "$quote" ]] && [[ "$c" == "$quote" ]]; then
      quote=''
      quote_idx=''
    # Handle whitespace delimiters when outside of quotes
    elif [[ -z "$quote" ]] && [[ "$c" =~ [[:space:]] ]] ; then
      result+=("$token")
      token=''
    # End of input
    elif [[ $i == "${#input}" ]] && [[ -n "$token" ]] ; then
      if [[ -n "$quote" ]] ; then
        echo "Unexpected end of string, quote not closed from index $quote_idx" >&2
        return 1
      fi
      result+=("$token")
      token=''
    # Any other token
    else
      # Detect unescaped dollar signs in double quotes
      if [[ "$c" == '$' ]] && [[ "$quote" == '"' ]] ; then
        return 100
      # Detect shell characters when not quoted
      elif [[ -z "$quote" ]] && [[ "$c" =~ [][\!\#\$\&\(\)\*\;\<\>\?\\\^\`\{\}] ]] ; then
        return 100
      fi
      token+="$c"
    fi
  done
}

output_quoted_shell_string() {
  result=()
  tokenize_shell_string "$1" || return $?
  printf "[%q]" "${result[@]}"
}
