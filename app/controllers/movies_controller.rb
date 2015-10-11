class MoviesController < ApplicationController
 @@count=0
  # See Section 4.5: Strong Parameters below for an explanation of this method:
  # http://guides.rubyonrails.org/action_controller_overview.html
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
    
     
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
   
  
   @all_ratings = Movie.all_ratings    
    redirect =false
if params[:sort_by]
@sort_by = params[:sort_by]
session[:sort_by] = params[:sort_by]
elsif session[:sort_by]
@sort_by = session[:sort_by]
redirect = true
else
@sort_by =nil
end


if params[:commit] =="Refresh" and params[:ratings].nil?
@ratings =nil
session[:ratings] =nil
elsif params[:ratings]
@ratings = params[:ratings]
session[:ratings] =params[:ratings]
elsif session[:ratings]
@ratings =session[:ratings]
redirect =true
else
@ratings =nil
end

if redirect
flash.keep
redirect_to movies_path :sort_by => @sort_by, :ratings => @ratings
end

   
   
   #########################################################################
   
    if @@count==0 
       @@count=1
    else @@count=2
    end  
     
    @movies=Movie.all()
    @movies=@movies.order(@sort_by)
    @sort_column = @sort_by
    
#    @all_ratings= Movie.all_ratings
    @temp=@ratings.to_a
    @set_ratings=Hash.new()
    @temp.each{ |x|
    y=x[0]
    @set_ratings[y] = 0}
     
  
    if @set_ratings
      @movies=Movie.where(rating: @set_ratings.keys).order(@sort_by)
         @set_ratings.each { |x,y|
         @set_ratings[x]=1 }
    end
   
    if @@count==1
       session.clear
     @movies=Movie.all()
     @all_ratings.each { |x|
     @set_ratings[x] = 1
     }
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

  private :movie_params
  
end


