#Erica Chai
#PA02_Movies

require "./validator.rb"
#Has one key method, run, which instantiates and invokes the other two classes.
#It’s the top level of your program.
class Control

  def run
    Validator.new
  end

end


beginning_time = Time.now #Benchmark time begin
Control.new.run
end_time = Time.now #Benchmark time end
puts "Time elapsed: #{end_time - beginning_time}"
