$test_set = Hash.new
$unique_user_id = []
input_file = ARGV.first

#Takes two instances of Ratings, one representing a base set and the other
#representing a test set. Has one important method, validate, which runs through
#all the entries in the test set and see what ratings would be predicted vs.
#which ones were given.

class Validator
  #Runs through test set and creates a new Ratings class for each user

  test_ratings = Ratings.new
  test_ratings.initialize(input_file)

  #Perhaps loads file in another class? This should be file of 20,000 records
  def load_data(input_file)
    user_id = []
    movie_id = []
    rating = []
    timestamp = []

    File.foreach("#{input_file}") do |line|
      data_row = line.split(' ')
      user_id.push(data_row[0])
      movie_id.push(data_row[1])
      rating.push(data_row[2])
      timestamp.push(data_row[3])
    end

    $test_set['user_id'] = user_id
    $test_set['movie_id'] = movie_id
    $test_set['rating'] = rating
    $test_set['timestamp'] = timestamp

    $unique_user_id = user_id.uniq
  end

  def run_test
    count = 0
    $test_set.each do |user|
      #Goes through last 20,000 records and pass user and movie to predict
      predicted_rating = test_ratings.predict(user, $test_set['movie_id'].fetch(count))
      count += 1
      validate(predicted_rating, actual_rating)
    end
  end


  def validate
  end
end
