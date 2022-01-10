require 'benchmark'
require 'fiddle/import'

module FFIC
  extend Fiddle::Importer
  dlload File.expand_path('lib/fib/fibC.so', __dir__)
  extern 'unsigned int fib(unsigned int n)'
end

module FFIR
  extend Fiddle::Importer
  dlload File.expand_path('lib/fib/libfib.dylib', __dir__)
  extern 'unsigned int fib(unsigned int n)'
end

module FFIG
  extend Fiddle::Importer
  dlload File.expand_path('lib/fib/fibGo.so', __dir__)
  extern 'unsigned int fib(unsigned int n)'
end

def fib(n)
  n <= 1 ? n : fib(n - 1) + fib(n - 2)
end

Benchmark.bm do |x|
  (30..37).each do |i|
    x.report("RUST: fib(#{i})") { FFIR.fib(i) }
    x.report("GO  : fib(#{i})") { FFIG.fib(i) }
    x.report("C   : fib(#{i})") { FFIC.fib(i) }
    x.report("RUBY: fib(#{i})") { fib(i) }

    puts
    puts " #{FFIR.fib(i)} ".center(60, '=')
    puts
  end
end
