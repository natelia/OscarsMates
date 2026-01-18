require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a name, email and password' do
    user = described_class.new(name: 'Admin', email: 'admin@example.com', password: 'password')
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = described_class.new(name: nil, email: 'admin@example.com', password: 'password')
    expect(user).not_to be_valid
  end

  it 'is invalid without an email' do
    user = described_class.new(name: 'Admin', email: nil, password: 'password')
    expect(user).not_to be_valid
  end
end
