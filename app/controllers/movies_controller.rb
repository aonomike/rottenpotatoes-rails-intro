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
  #  session[:ratings] = params[:ratings] ? params[:ratings] : []
    session[:ratings] = params[:ratings] if params[:ratings]


    session[:sort_by] = params[:sort_by] if params[:sort_by]
    @selected = session[:ratings]
    if session[:ratings]
      @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort_by])
    else
      @selected = Movie.select(:rating).map(&:rating).uniq
      @movies = Movie.all.order(session[:sort_by])
    end

    @hilite = {}
    @all_ratings = Movie.select(:rating).map(&:rating).uniq
    if session[:sort_by]
      @movies =  @movies.order(session[:sort_by])
      @hilite = {session[:sort_by] => 'hilite'}
    end
    # if session[:sort_by] and session[:ratings]
    #   redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
    # elsif session[:sort_by] and session[:ratings].nil?
    #   redirect_to movies_path(sort_by: session[:sort_by])
    # elsif session[:sort_by].nil? and session[:ratings]
    #     redirect_to movies_path(ratings: session[:ratings])
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
