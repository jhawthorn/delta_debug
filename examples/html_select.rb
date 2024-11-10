require "delta_debug"

input = '<SELECT NAME="priority" MULTIPLE SIZE=7>'
harness = -> (html) do
  if html =~ /<SELECT\b.*>/
    puts "found failure: #{html.dump}"
    true
  else
    false
  end
end

result = DeltaDebug.new(harness).ddmin(input)
p(result:)
