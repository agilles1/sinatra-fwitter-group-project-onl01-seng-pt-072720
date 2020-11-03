# class TweetsController < ApplicationController
#     get '/tweets' do 
#         if !logged_in?
#             erb :'users/login'
#         else
#             @user = current_user
#             @tweets = Tweet.all 
#             erb :'tweets/tweets'
#         end
#     end

#     get '/tweets/new' do 
#         if !logged_in?
#             erb :'users/login'
#         else
#         erb :'tweets/new'
#         end
#     end

#     post '/tweets' do
#      tweet = Tweet.create(content: params[:content], user_id: current_user.id)
#      redirect to "/tweets"
#     end

#     get '/tweets/:id' do
#         if !logged_in?
#             erb :'users/login'
#         else
#         @user = current_user
#         @tweet = Tweet.find(params[:id])

#         erb :'tweets/show_tweet'
#         end
#     end

#     get '/tweets/:id/edit' do
#         if !logged_in?
#             erb :'users/login'
#         else
#         @user = current_user
#         @tweet = Tweet.find(params[:id])
#         binding.pry
#         erb :'tweets/edit_tweet'
#         end
#     end

#     patch '/tweets/:id' do
#         tweet = Tweet.find(params[:id])
#         tweet.content = params[:content]
#         tweet.save
#         redirect to "/tweets/#{tweet.id}"
#     end

#     post '/tweets/:id/delete' do 
#         Tweet.find(params[:id]).destroy
#         redirect to '/tweets'
#     end

# end

class TweetsController < ApplicationController
    get '/tweets' do
      if logged_in?
        @tweets = Tweet.all
        erb :'tweets/tweets'
      else
        redirect to '/login'
      end
    end
  
    get '/tweets/new' do
      if logged_in?
        erb :'tweets/create_tweet'
      else
        redirect to '/login'
      end
    end
  
    post '/tweets' do
      if logged_in?
        if params[:content] == ""
          redirect to "/tweets/new"
        else
          @tweet = current_user.tweets.build(content: params[:content])
          if @tweet.save
            redirect to "/tweets/#{@tweet.id}"
          else
            redirect to "/tweets/new"
          end
        end
      else
        redirect to '/login'
      end
    end
  
    get '/tweets/:id' do
      if logged_in?
        @tweet = Tweet.find_by_id(params[:id])
        erb :'tweets/show_tweet'
      else
        redirect to '/login'
      end
    end
  
    get '/tweets/:id/edit' do
      if logged_in?
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet && @tweet.user == current_user
          erb :'tweets/edit_tweet'
        else
          redirect to '/tweets'
        end
      else
        redirect to '/login'
      end
    end
  
    patch '/tweets/:id' do
      if logged_in?
        if params[:content] == ""
          redirect to "/tweets/#{params[:id]}/edit"
        else
          @tweet = Tweet.find_by_id(params[:id])
          if @tweet && @tweet.user == current_user
            if @tweet.update(content: params[:content])
              redirect to "/tweets/#{@tweet.id}"
            else
              redirect to "/tweets/#{@tweet.id}/edit"
            end
          else
            redirect to '/tweets'
          end
        end
      else
        redirect to '/login'
      end
    end
  
    delete '/tweets/:id/delete' do
      if logged_in?
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet && @tweet.user == current_user
          @tweet.delete
        end
        redirect to '/tweets'
      else
        redirect to '/login'
      end
    end
  end
