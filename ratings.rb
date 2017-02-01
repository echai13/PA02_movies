#Erica Chai
#PA02 Movies

#takes in u.base file and used as training set
$similarity_list = Hash.new
$unique_user_data = []

class Ratings
  #Perhaps loads file in another class? This should be file of 20,000 records
  def load_data(input_file)
    user_id = []
    movie_rating = Hash.new
    count = 1
    line_num = 0

    File.foreach("#{input_file}") do |line|
      line_num += 1
      data_row = line.split(' ')
      user_id.push(data_row[0])

      if data_row[0].to_i == count.to_i
        movie_rating[data_row[1]] = data_row[2]
      end
      if data_row[0].to_i != count.to_i || line_num == 80000
        $unique_user_data.push(movie_rating)
        movie_rating = Hash.new
        movie_rating[data_row[1]] = data_row[2]
        count += 1
      end
    end
    $unique_user_id = user_id.uniq

    #$unique_user_id = user_id.uniq
    puts "done with ratings load_data"
    puts $unique_user_data.length

  end


  def predict(user, movie)
    list = most_similar(user) #array of similar users
    done = true
    count = 0
    user_predicted_rating = 0;

    #see which user has seen the movie
    while done && !list.empty?
      first_user = list.shift #user similar to u

      if $unique_user_data[first_user.to_i - 1].has_key?(movie)
        user_predicted_rating = $unique_user_data[first_user.to_i - 1][movie]
        return user_predicted_rating
      end
    end
    return user_predicted_rating
  end


#From PA01_Movies:
#this will generate a number which indicates the similarity
#in movie preference between user1 and user2 (where higher
#numbers indicate greater similarity)
  def similarity(user1, user2)
    count = 0
    similar_movies_avg = []

#fill in user1_data and user2_data
#find similar watched movies, remove differences in both lists
    $unique_user_data[user1.to_i - 1].each_key {|movieId, rating|
      if $unique_user_data[user2.to_i - 1].has_key?(movieId)
        similar_movies_avg.push((rating.to_i - $unique_user_data[user2.to_i - 1][movieId].to_i).abs)
      end
    }

    #find average
     return similar_movies_avg.inject{ |sum, el| sum + el }.to_f / similar_movies_avg.size
   end


#From PA01_Movies
#this return a hash of users whose tastes are most similar
#to the tastes of user u and their similarity score in descending order
  def most_similar(u)

    if $similarity_list.any? && $similarity_list.has_key?(u)
      return $similarity_list[u]
    end

    similar_users = Hash.new
    $unique_user_id.each do |user|
      num = similarity(u, user)
      if num >= 3.0
        similar_users[user] = num
      end
    end
    
    $similarity_list[u] = (Hash[similar_users.sort_by {|k,v| v}.reverse]).keys
    return $similarity_list[u]
  end
end
