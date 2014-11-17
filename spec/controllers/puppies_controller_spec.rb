require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe PuppiesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Puppy. As you add validations to Puppy, be sure to
  # adjust the attributes here as well.
  let!(:breed) { FactoryGirl.create(:breed) }
  let(:valid_attributes) {
    { name: "Buddy", breed_id: breed.id }
  }

  let(:invalid_attributes) {
    { name: "" }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PuppiesController. Be sure to keep this updated too.
  let(:valid_session) { {} }


  # API TESTS
  ######################################################
  describe "via API calls" do
    let(:json) { JSON.parse(response.body) }
    render_views

    describe "GET /puppies.json" do
      before do
        duke = FactoryGirl.create(:puppy, name: "Duke")
        spot = FactoryGirl.create(:puppy, name: "Spot")
        get :index, format: :json
      end

      it "returns success code" do
        expect(response.status).to eq(200)
      end
      
      it "returns puppies" do  
        names = json.collect { |n| n["name"] }
        expect(names).to eq(["Duke", "Spot"])
      end
    end

    describe "POST /puppies.json" do
      context "successful puppy listing" do
        before { post :create, format: :json, :puppy => { name: "Sadie", breed_id: "#{breed.id}"} }

        it "returns success code" do
          expect(response.status).to eq(201)
        end

        it "adds new puppy" do
          expect(Puppy.last.name).to eq("Sadie")
        end

        it "returns puppy url" do
          expect(response.location).to eq(puppy_url(Puppy.last))
        end
      end  

      context "invalid puppy - no breed" do
        before { post :create, format: :json, :puppy => { name: "Elmo" } }

        it "returns failure code" do
          expect(response.status).to eq(422)
        end
      end

      context "invalid puppy - nonexistant breed" do
        before do
          bad_id = Breed.last.id + 5
          post :create, format: :json, :puppy => { name: "Mutt", breed_id: bad_id }
        end

        it "returns failure code" do
          expect(response.status).to eq(422)
        end
      end
    end

    describe 'DELETE (ADOPT) /puppies/:id.json' do
      let!(:adoptee) { FactoryGirl.create(:puppy) }

      context 'successful adoption' do
        it 'removes the puppy from the db' do
          delete :destroy, format: :json, id: "#{adoptee.id}"
          expect(Puppy.where(id: "#{adoptee.id}")).to be_empty
        end
      end
    end
  end

  # STANDARD TESTS
  ######################################################
  describe "GET index" do
    it "assigns all puppies as @puppies" do
      puppy = Puppy.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:puppies)).to eq([puppy])
    end
  end

  describe "GET show" do
    it "assigns the requested puppy as @puppy" do
      puppy = Puppy.create! valid_attributes
      get :show, {:id => puppy.to_param}, valid_session
      expect(assigns(:puppy)).to eq(puppy)
    end
  end

  describe "GET new" do
    it "assigns a new puppy as @puppy" do
      get :new, {}, valid_session
      expect(assigns(:puppy)).to be_a_new(Puppy)
    end
  end

  describe "GET edit" do
    it "assigns the requested puppy as @puppy" do
      puppy = Puppy.create! valid_attributes
      get :edit, {:id => puppy.to_param}, valid_session
      expect(assigns(:puppy)).to eq(puppy)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Puppy" do
        expect {
          post :create, {:puppy => valid_attributes}, valid_session
        }.to change(Puppy, :count).by(1)
      end

      it "assigns a newly created puppy as @puppy" do
        post :create, {:puppy => valid_attributes}, valid_session
        expect(assigns(:puppy)).to be_a(Puppy)
        expect(assigns(:puppy)).to be_persisted
      end

      it "redirects to the created puppy" do
        post :create, {:puppy => valid_attributes}, valid_session
        expect(response).to redirect_to(Puppy.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved puppy as @puppy" do
        post :create, {:puppy => invalid_attributes}, valid_session
        expect(assigns(:puppy)).to be_a_new(Puppy)
      end

      it "re-renders the 'new' template" do
        post :create, {:puppy => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested puppy" do
        puppy = Puppy.create! valid_attributes
        put :update, {:id => puppy.to_param, :puppy => new_attributes}, valid_session
        puppy.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested puppy as @puppy" do
        puppy = Puppy.create! valid_attributes
        put :update, {:id => puppy.to_param, :puppy => valid_attributes}, valid_session
        expect(assigns(:puppy)).to eq(puppy)
      end

      it "redirects to the puppy" do
        puppy = Puppy.create! valid_attributes
        put :update, {:id => puppy.to_param, :puppy => valid_attributes}, valid_session
        expect(response).to redirect_to(puppy)
      end
    end

    describe "with invalid params" do
      it "assigns the puppy as @puppy" do
        puppy = Puppy.create! valid_attributes
        put :update, {:id => puppy.to_param, :puppy => invalid_attributes}, valid_session
        expect(assigns(:puppy)).to eq(puppy)
      end

      it "re-renders the 'edit' template" do
        puppy = Puppy.create! valid_attributes
        put :update, {:id => puppy.to_param, :puppy => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested puppy" do
      puppy = Puppy.create! valid_attributes
      expect {
        delete :destroy, {:id => puppy.to_param}, valid_session
      }.to change(Puppy, :count).by(-1)
    end

    it "redirects to the puppies list" do
      puppy = Puppy.create! valid_attributes
      delete :destroy, {:id => puppy.to_param}, valid_session
      expect(response).to redirect_to(puppies_url)
    end
  end

end