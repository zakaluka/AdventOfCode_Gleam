import gleam/io

pub fn tee(f, x) {
  f(x)
  x
}

pub fn teed(x) {
  tee(io.debug, x)
  x
}
