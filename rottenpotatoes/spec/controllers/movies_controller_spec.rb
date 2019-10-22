require 'rails_helper'

describe MoviesController do
        
#CRUD operations
#Create a row/movie C
  describe "create" do
    it "create movie with provided parameters" do
        @defaults = {title: "Test", rating: "G", director: "XYZ"}
        
        post :create, movie: @defaults
        expect(flash[:notice]).to eq("Test was successfully created.")
        expect(response).to redirect_to(movies_path)
    end
  end
   describe "new" do
    it "render the new template" do
        get :new 
        expect(response).to render_template(:new)
    end
  end
  
  #Read - R
  describe "show" do
    it "display details about an existing movie" do
        @id = "-1"
        @movie = double('null movie').as_null_object
        expect(Movie).to receive(:find).and_return(@movie)
        get :show, id: @id
        expect(response).to render_template(:show)
    end
  end
  #Update - U
   describe "edit" do
    it "edit an existing movie" do
        @id = "-1"
        @movie = double('null movie').as_null_object
        expect(Movie).to receive(:find).and_return(@movie)
        
        get :edit, id: @id
        expect(response).to render_template(:edit)
    end
  end
  describe "update" do
    it "update existing movie" do
        @id = "-1"
        @movie = double('null movie').as_null_object
        @defaults = {title: "Test", rating: "R", director: "Bill"}
        expect(Movie).to receive(:find).with(@id).and_return(@movie)
        
        put :update, id: @id, movie: @defaults
        expect(flash[:notice]).to match(/was successfully updated./)
        expect(response).to redirect_to(movie_path(@movie))
    end
  end
  #Destroy - D
  describe "destroy" do
    it "delete the specific movie" do
        @id = "-1"
        @movie = double('null movie').as_null_object
        expect(Movie).to receive(:find).with(@id).and_return(@movie)
        
        delete :destroy, id: @id
        expect(flash[:notice]).to match(/Movie || deleted./)
        expect(response).to redirect_to(movies_path)
    end
  end
  
  #HW2 soting test
  describe "sorting movies" do
    it "sort with selected_ratings" do 
        get :index, sort: "title"
        expect(response.body).to include "ratings"
    end
    it "sort with release_date" do 
        get :index, sort: "release_date"
        expect(response.body).to include "release_date"
    end 
  end
    
    #HW3 Happy oath
  describe "director" do
        context "When specified movie has a director" do
            
            it "find movies with the same director" do
            
            @id = "-1"
            @movie = double('Test', director: 'Alex')
            
            expect(Movie).to receive(:find).with(@id).and_return(@movie)
            expect(@movie).to receive(:director)
            
            get :similar_movies, id: @id
            
            expect(response).to render_template(:similar_movies)
        end
    end
    #HW3 Sad Path
    context "When specified movie has no director" do
            it "redirect to the movies page" do
                @id = "-1"
                @movie = double('null movie').as_null_object
                expect(Movie).to receive(:find).with(@id).and_return(@movie)
                get :similar_movies, id: @id
                #expect(flash[:notice]).to eq("/has no director info./")
                expect(response).to render_template(:similar_movies)
            
            end
        end
    end
end