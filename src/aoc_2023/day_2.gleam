import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utility.{teed}

pub type Color {
  Red
  Green
  Blue
}

fn string_to_color(s) {
  case s {
    "red" -> Red
    "green" -> Green
    "blue" -> Blue
    _ -> panic as "Unknown color"
  }
}

fn is_valid_game(ci) {
  let r = dict.get(ci, Red) |> result.unwrap(0)
  let g = dict.get(ci, Green) |> result.unwrap(0)
  let b = dict.get(ci, Blue) |> result.unwrap(0)
  r >= 0 && r <= 12 && g >= 0 && g <= 13 && b >= 0 && b <= 14
}

// Turns a string representing the results of a game into dictionary of each 
// color and the max used for that color in a single hand.
fn parse_game(full_game) {
  full_game
  |> string.replace(";", "")
  |> string.replace(",", "")
  |> string.split(" ")
  |> list.sized_chunk(2)
  |> list.map(fn(e) {
    case e {
      [n, c] -> #(string_to_color(c), int.parse(n) |> result.unwrap(0))
      _ -> panic as "impossible"
    }
  })
  |> list.group(fn(e) { e.0 })
  |> dict.map_values(fn(_c, l) {
    list.map(l, fn(indiv_value) { indiv_value.1 })
    |> list.fold(0, int.max)
  })
}

// Sequence of events
// - Split the string into multiple lines
// - For each line, split the string into Game # + Values 
//   - Assert
// - 
pub fn pt_1(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(string.split_once(_, ": "))
  |> list.map(result.unwrap(_, #("", "")))
  |> list.map(fn(e) {
    let g = e.0 |> string.drop_left(up_to: 5) |> int.parse |> result.unwrap(-1)
    let c = parse_game(e.1)
    #(is_valid_game(c), g)
  })
  |> list.key_filter(True)
  |> list.fold(0, int.add)
}

pub fn pt_2(input: String) {
  input
  |> string.split(on: "\n")
  |> list.map(string.split_once(_, ": "))
  |> list.map(result.unwrap(_, #("", "")))
  |> list.map(fn(e) {
    // let g = e.0 |> string.drop_left(up_to: 5) |> int.parse |> result.unwrap(-1)
    let c = parse_game(e.1)
    dict.values(c) |> list.fold(1, int.multiply)
  })
  |> teed
  |> list.fold(0, int.add)
}
