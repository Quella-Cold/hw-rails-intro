class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      #initial the parameters
      @rated = Movie.get_rated
      sequence = params[:sort]
      filt_rating = params[:ratings]
      #puts(filt_rating)
      if filt_rating != nil
      #  @movies = Movie.with_rated(filt_rating)
      #  return
        session[:filt_rating] = filt_rating 
      end

      if sequence != nil
        session[:sequence] = sequence
      end
      
      if sequence == nil
        if filt_rating == nil 
          if (session[:filt_rating] != nil or session[:sequence] != nil)
            filt_rating = session[:filt_rating]
            sequence = session[:sequence]
            flash.keep
            redirect_to movies_path({sort:sequence, ratings:filt_rating})
          end
        end
      end
      
      sequence = session[:sequence]
      filt_rating = session[:filt_rating]
      
      if sequence == nil
        @movies = Movie.all()
      else
        @movies = Movie.all().order(sequence)
        if sequence == 'title'
          @name = 'bg-warning'
        elsif sequence == 'release_date'
          @time = 'bg-warning'
        end
      end
    

      if filt_rating != nil
        @movies = @movies.select{|movie| filt_rating.include? movie.rating}
      end
      
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end
