import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

fn get_first_number(input_string: String) {
  case string.pop_grapheme(input_string) {
    Error(Nil) -> panic as "Unable to get a number from the string"
    Ok(#(first, rest)) ->
      case int.parse(first) {
        Ok(i) -> i
        Error(_) -> get_first_number(rest)
      }
  }
}

pub fn pt_1(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(fn(s) {
    { { get_first_number(s) } * 10 } + { get_first_number(string.reverse(s)) }
  })
  |> list.fold(0, fn(acc, e) { acc + e })
}

fn map_digit(in_words: String) {
  case in_words {
    "one" | "eno" | "1" -> 1
    "two" | "owt" | "2" -> 2
    "three" | "eerht" | "3" -> 3
    "four" | "ruof" | "4" -> 4
    "five" | "evif" | "5" -> 5
    "six" | "xis" | "6" -> 6
    "seven" | "neves" | "7" -> 7
    "eight" | "thgie" | "8" -> 8
    "nine" | "enin" | "9" -> 9
    "zero" | "orez" | "0" -> 0
    _ -> {
      io.debug(in_words)
      panic as { "Cannot map " <> in_words <> " to a digit." }
    }
  }
}

fn get_number_with_index(find: String, line: String) -> Result(#(Int, Int), Nil) {
  line
  |> string.split_once(on: find)
  |> result.map(fn(s) { #(string.length(s.0), map_digit(find)) })
}

fn find_nth_digit(raw_line: String, first: Bool) -> Int {
  let digits_to_find = {
    case first {
      True -> [
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two", "three",
        "four", "five", "six", "seven", "eight", "nine", "zero",
      ]
      False ->
        [
          "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two",
          "three", "four", "five", "six", "seven", "eight", "nine", "zero",
        ]
        |> list.map(string.reverse)
    }
  }

  let line = case first {
    True -> raw_line
    False -> string.reverse(raw_line)
  }

  digits_to_find
  |> list.map(get_number_with_index(_, line))
  |> list.filter(result.is_ok)
  |> list.map(result.unwrap(_, or: #(999_999, 999_999)))
  |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
  |> list.map(fn(a) { a.1 })
  |> list.first()
  |> result.unwrap(or: 999_999)
}

pub fn pt_2(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(fn(s) { find_nth_digit(s, True) * 10 + find_nth_digit(s, False) })
  |> list.fold(0, fn(acc, e) { acc + e })
}
