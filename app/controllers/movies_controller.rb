class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    # # if params[:sort] == 'title'
    # #       @movies = Movie.order('title')
    # # elsif params[:sort] == 'date'
    # #       @movies = Movie.order('release_date')
    if params[:sort]
        session[:sort] = params[:sort]
        @movies = Movie.all.order(params[:sort])
    elsif session[:sort]
        @movies = Movie.all.order(session[:sort])
    else
        @movies = Movie.all
    end
    @all_ratings = Movie.all_ratings
    if params[:ratings]
          @selected_ratings = params[:ratings].keys
          # @selected_ratings = params[:ratings].keys
          session[:ratings] = params[:ratings]
          @selected_ratings = session[:ratings].keys
    elsif session[:ratings]
          @selected_ratings = session[:ratings].keys
    else
          @selected_ratings = @all_ratings
    end
    @movies = @movies.where(:rating => @selected_ratings)
    # if params[:sort]
    #     session[:sort] = params[:sort]
    #     @movies = Movie.all.order(params[:sort])
    # elsif session[:sort]
    #     @movies = Movie.all.order(session[:sort])
    # else
    #     @movies = Movie.all
    # end
    # if params[:sort]
    #       @movies = Movie.all.order(params[:sort])
    # else
    #       @movies = Movie.all
    # end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
