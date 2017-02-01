require "./validator.rb"
#Has one key method, run, which instantiates and invokes the other two classes.
#It’s the top level of your program.

class Control

  def run
    validator = Validator.new
  end

end

start = Control.new
start.run()
