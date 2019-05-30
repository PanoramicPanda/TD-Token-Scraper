require_relative '../token.rb'

describe Token do

  describe '.name' do
    context 'given a string' do
      it 'sets the name of the token' do
        token = Token.new
        token.name = 'Bob'
        expect(token.name).to eql 'Bob'
      end
    end
  end

end