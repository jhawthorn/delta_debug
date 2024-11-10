# frozen_string_literal: true

require "delta_debug/version"

# https://www.st.cs.uni-saarland.de/papers/tse2002/tse2002.pdf
class DeltaDebug
  def initialize(harness, verbose: $DEBUG)
    @harness = harness
    @verbose = verbose
  end

  attr_reader :verbose

  def run_test(input)
    print "testing #{input.inspect} = " if verbose
    result = @harness.call(input)
    p(result ? :pass : :fail) if verbose
    !result
  end

  def ddmin(input)
    convert_input = ->(x) { x }
    if String === input
      input = input.chars
      convert_input = ->(x) { x.join }
    end

    is_failure = Hash.new do |h, k|
      h[k] = run_test(convert_input.call(k))
    end

    raise "given input passes test" unless is_failure[input]
    return [] if is_failure[[]]

    n = 2
    while input.length > 1
      puts "trying #{input.inspect} n=#{n}" if verbose
      segments = split(input, n)
      if failing_segment = segments.detect { |x| is_failure[x] }
        input = failing_segment
        n = 2
        next
      end

      complements = complements(segments)
      if failing_complement = complements.detect { |x| is_failure[x] }
        input = failing_complement
        n -= 1
        next
      end

      if n < input.length
        n = [n*2, input.length].min
      else
        break
      end
    end

    convert_input.call(input)
  end

  def complements(segments)
    # Technically the complement of segments for n=2 is segments, but that's not useful as we would have already tested that
    return [] if segments.length == 2

    (segments.length).times.map do |n|
      [*segments[0, n], *segments[n+1, segments.length]].flatten(1)
    end
  end

  def split(input, n)
    step = (input.size + n - 1) / n
    input.each_slice(step).to_a
  end
end
