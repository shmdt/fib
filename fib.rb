require 'benchmark'
require 'fiddle/import'

# C
module FFIC
  extend Fiddle::Importer
  dlload File.expand_path('lib/fib/fibC.so', __dir__)
  extern 'unsigned int fib(unsigned int n)'
end

# Rust
module FFIR
  extend Fiddle::Importer
  dlload File.expand_path('lib/fib/libfib.dylib', __dir__)
  extern 'unsigned int fib(unsigned int n)'
end

# Golang
module FFIG
  extend Fiddle::Importer
  dlload File.expand_path('lib/fib/fibGo.so', __dir__)
  extern 'unsigned int fib(unsigned int n)'
end

# Ruby
def fib(n)
  n <= 1 ? n : fib(n - 1) + fib(n - 2)
end

# Ruby optimized with Hash
def opt_fib
  Hash.new { |hash, key| hash[key] = key < 2 ? key : hash[key-1] + hash[key-2] }
end

# Ruby optimized with Array
@cache = [0,1]

def opt_fib_2(n)
  return @cache[n] if @cache[n]

  @cache[n] = opt_fib_2(n-1) + opt_fib_2(n-2)
end

Benchmark.bm do |x|
  (30..37).each do |i|
    x.report("RUST: fib(#{i})") { FFIR.fib(i) }
    x.report("GO  : fib(#{i})") { FFIG.fib(i) }
    x.report("C   : fib(#{i})") { FFIC.fib(i) }
    x.report("RUBY: fib(#{i})") { fib(i) }
    x.report("OPT1: fib(#{i})") { opt_fib[i] }
    x.report("OPT1: fib(#{i})") { opt_fib_2(i) }

    puts " #{FFIR.fib(i)} ".center(60, '=')
    puts " #{FFIG.fib(i)} ".center(60, '=')
    puts " #{FFIC.fib(i)} ".center(60, '=')
    puts " #{fib(i)} ".center(60, '=')
    puts " #{opt_fib[i]} ".center(60, '=')
    puts " #{opt_fib_2(i)} ".center(60, '=')
    puts
  end
end
