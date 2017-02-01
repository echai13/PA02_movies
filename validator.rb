#Erica Chai
#PA02_Movies

require "./ratings.rb"
require 'descriptive_statistics/safe'

$test_set = []
$array_of_predictions = []
$test_ratings = Ratings.new

$num_correct = 0
$num_wrong = 0
$rating_one_away = 0
$avg = 0.0
$stats = 0.0

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

  #calls on Ratings class to predict the ratings for validation
  def run_test
    count = 0
    #puts $test_set
    while count <= 460
      if $test_set[count].any?
        $test_set[count].each do |movie, actual_rating|
          predicted_rating = $test_ratings.predict(count + 1, movie)
          puts "Done predicting..."
          #puts "#{count + 1} and #{predicted_rating} and #{movie}"
          validate(predicted_rating.to_f, actual_rating.to_f)
        end
      end
      count += 1
    end

    $avg = DescriptiveStatistics.mean($array_of_predictions)
    $stats = DescriptiveStatistics::Stats.new($array_of_predictions).standard_deviation

    puts "Number of correct: #{$num_correct}, Number of wrong: #{$num_wrong}, Number of \"close\" guesses: #{$rating_one_away}"
    puts "Average: #{$avg}, Standard Deviation: #{$stats}"
  end

  #Load u.test into data structure to see which users need prediction
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
          puts "Enter"
          $test_set.push({})
          $test_set.push(movie_rating)
        end

      end
    end
    puts $test_set
    puts "done with adding data in validator"
  end

  #add ratings to array and keep track of corrects, wrongs, and close guesses
  def validate(predicted, actual)
    $array_of_predictions.push(predicted)
    $array_of_predictions.push(actual)

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
