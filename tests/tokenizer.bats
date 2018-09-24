#!/usr/bin/env bats

load "../tokenizer"

# dangerous_eval_tokenize_shell_string() {
#   eval "result=($1)"
# }

@test "A string with no quotes" {
  output=$(output_quoted_shell_string 'this is a string')
  [ $? -eq 0 ]
  [ $output = '[this][is][a][string]' ]
}

@test "A single quoted string" {
  output=$(output_quoted_shell_string "this 'is  a' string")
  [ $? -eq 0 ]
  echo $output
  [ "$output" = '[this][is\ \ a][string]' ]
}

@test "A quoted string with newlines" {
  output=$(output_quoted_shell_string $'this "is\na" string')
  [ $? -eq 0 ]
  echo $output
  [ "$output" = "[this][\$'is\na'][string]" ]
}

@test "A quoted string with escaped end quotes" {
  output=$(output_quoted_shell_string 'this "is \\\"\"a" string')
  [ $? -eq 0 ]
  echo "$output"
  [ "$output" = '[this][is\ \\\"\"a][string]' ]
}

