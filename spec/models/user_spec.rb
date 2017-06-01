require 'rails_helper'

RSpec.describe User, type: :model do
  
  subject {
    described_class.new( email: "test@example.com", name: "teste", 
                         password: '123456', password_confirmation:'123456')
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  
  it "is valid with default role" do
    subject.save!
    expect(subject.role).to eq(Role.find_by_name('user'))
  end
  
  it "is not valid without an email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end
  
  it "is not valid with an existing email" do
    User.create(email: "test@example.com", name: "teste", 
                password: '123456', password_confirmation:'123456')    
    expect(subject).to_not be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end
  
  it "is not valid without a role" do
    subject.role = nil
    expect(subject).to_not be_valid
  end
  
  it "is possible to change the role" do
    subject.role = Role.find_by_name('admin')
    subject.save!
    expect(subject.role).to eq(Role.find_by_name('admin'))
  end
  
  it "is not valid if password doesn't match with password_confirmation" do
    subject.password = '1234567'
    expect(subject).to_not be_valid
  end
  
  it "is not valid if password doesn't match with password_confirmation" do
    subject.password_confirmation = '1234567'
    expect(subject).to_not be_valid
  end
  
  it "is not valid if password has less than 6 characteres" do
    subject.password = '12345'
    subject.password_confirmation = '12345'
    expect(subject).to_not be_valid
  end
  
  it "has a photo's default url" do
    expect(subject.photo_url).to eq('/defaults/photos/user.png')
  end
  
  it "is possible to do the login" do
    subject.save!
    user = User.new
    expect(user.login_api(subject.email, '123456')[:user][:email]).to eq(subject.email)
  end
  
  it "is not possible to do the login with wrong email or password" do
    subject.save!
    user = User.new
    expect { user.login_api(subject.email, '1234567') }.to raise_error(RuntimeError, "Invalid user or password")
  end
  
  it "is return a valid token" do
    subject.save!
    user = User.new
    expect(user.login_api(subject.email, '123456')[:token]).to eq(UserApi.find_by_user_id(subject.id).token)
  end
  
end
