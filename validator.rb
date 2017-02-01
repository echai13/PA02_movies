require "./ratings.rb"
require 'descriptive_statistics/safe'

$test_set = []
#$unique_user_id = []
$test_ratings = Ratings.new

$num_correct = 0
$num_wrong = 0
$rating_one_away = 0

#Has one important method, validate, which runs through
#all the entries in the test set and see what ratings would be predicted vs.
#which ones were given.

class Validator
  #Runs through test set and creates a new Ratings class for each user
  def initialize
    $test_ratings.load_data("u1.base")
    self.load_data("u1.test")
    self.run_test()
  end


  def run_test
    puts $test_set
    count = 0
    #puts $test_set
    while count <= 460
      if $test_set[count].any?
        $test_set[count].each do |movie, actual_rating|
          predicted_rating = $test_ratings.predict(count + 1, movie)
          #puts "#{count + 1} and #{predicted_rating} and #{movie}"
          validate(predicted_rating, actual_rating)
        end
      end
      count += 1
      puts "Number of correct: #{$num_correct}, Number of wrong: #{$num_wrong}, Number of one aways: #{$rating_one_away}"
    end


  end

  #Perhaps loads file in another class? This should be file of 20,000 records
  def load_data(input_file)
    movie_rating = Hash.new
    count = 1
    line_num = 0

    File.foreach("#{input_file}") do |line|
      line_num += 1
      data_row = line.split(' ')
      if data_row[0].to_i == count.to_i
        movie_rating[data_row[1]] = data_row[2]
      else
        $test_set.push(movie_rating)
        movie_rating = Hash.new
        movie_rating[data_row[1]] = data_row[2]
        count += 1
        if line_num == 20000
          $test_set.push({})
          $test_set.push(data_row[0])
        end
        puts count
      end
    end
    puts "done with adding data in validator"
  end


  def validate(predicted, actual)
    avg = DescriptiveStatistics.mean([predicted.to_i, actual.to_i])
    stats = DescriptiveStatistics::Stats.new([predicted.to_i, actual.to_i])
    sd = stats.standard_deviation

    puts "Average: #{avg}, SD: #{sd}"

    if predicted.to_i == actual.to_i
      $num_correct += 1
    else
      if predicted.to_i - 1 == actual.to_i || predicted.to_i + 1 == actual.to_i
        $rating_one_away += 1
      end
      $num_wrong += 1
    end
  end
end
