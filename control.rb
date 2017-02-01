require "./validator.rb"
#Has one key method, run, which instantiates and invokes the other two classes.
#It’s the top level of your program.

class Control

  def run
    Validator.new
  end

end

Control.new.run
