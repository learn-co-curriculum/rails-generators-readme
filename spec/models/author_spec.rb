require 'rails_helper'

RSpec.describe Author, type: :model do
  it "has a name" do
    @author = Author.new
    @author.name = "Joe Burgess"
    expect(@author.name).to eq("Joe Burgess")
  end

  it "has a genre" do
    @author = Author.new
    @author.genre = "Fiction"
    expect(@author.genre).to eq("Fiction")
  end

  it "has a bio" do
    @author = Author.new
    @author.bio = "I'm a Teacher!"
    expect(@author.bio).to eq("I'm a Teacher!")
  end
end
