require_relative '../token.rb'

describe Token do
  token = Token.new

  describe '.name' do
    context 'given a string' do
      it 'sets the name of the token' do
        token.name = 'Bob'
        expect(token.name).to eql 'Bob'
      end
    end
  end

  describe '.link' do
    context 'given a string' do
      it 'sets the link of the token' do
        token.link = 'http://tokendb.com/token/gauntlets-of-ogre-power/'
        expect(token.link).to eql 'http://tokendb.com/token/gauntlets-of-ogre-power/'
      end
    end
  end

  describe '.add_class' do
    context 'given a string' do
      it 'becomes an array with a single entry' do
        token.add_class('Barbarian')
        expect(token.classes).to eql ['Barbarian']
      end
      it 'adds the string to the array' do
        token.add_class('Bard')
        expect(token.classes).to eql ['Barbarian', 'Bard']
      end
    end
  end

  describe '.rarity' do
    context 'given a string' do
      it 'sets the rarity of the token' do
        token.rarity = 'Rare'
        expect(token.rarity).to eql 'Rare'
      end
    end
  end

  describe '.slot' do
    context 'given a string' do
      it 'sets the slot of the token' do
        token.slot = 'Hands'
        expect(token.slot).to eql 'Hands'
      end
    end
  end

  describe '.add_year' do
    context 'given a string' do
      it 'becomes an array with a single entry' do
        token.add_year('2012')
        expect(token.years).to eql ['2012']
      end
      it 'adds the string to the array' do
        token.add_year('2016')
        expect(token.years).to eql ['2012', '2016']
      end
    end
  end

  describe '.exchange_points' do
    context 'given a string' do
      it 'sets the amount of exchange points' do
        token.exchange_points = '6'
        expect(token.exchange_points).to eql '6'
      end
    end
  end

  describe '.add_exchange' do
    context 'given a string' do
      it 'becomes an array with a single entry' do
        token.add_exchange('Mystic Silk')
        expect(token.exchanges_to).to eql ['Mystic Silk']
      end
      it 'adds the string to the array' do
        token.add_exchange('Darkwood Plank')
        expect(token.exchanges_to).to eql ['Mystic Silk', 'Darkwood Plank']
      end
    end
  end

  describe '.add_source' do
    context 'given a string' do
      it 'becomes an array with a single entry' do
        token.add_source('Standard Pack')
        expect(token.sources).to eql ['Standard Pack']
      end
      it 'adds the string to the array' do
        token.add_source('Exchange')
        expect(token.sources).to eql ['Standard Pack', 'Exchange']
      end
    end
  end

  describe '.setup_token_image' do
    it 'sets the image name to a guid' do
      token.setup_token_image('http://tokendb.com/wp-content/uploads/2012/06/Gauntlets-of-Ogre-Power-100x100.jpg')
      expect(token.image_guid).to match /^[A-Z0-9]{32}.(jpg)|(png)|(jpeg)$/
    end
  end

  describe '.token_hash' do
    it 'returns a hash of the token object' do
      test_hash = {
          link: 'http://tokendb.com/token/gauntlets-of-ogre-power/',
          image: token.image_guid,
          classes: ['Barbarian', 'Bard'],
          rarity: 'Rare',
          slot: 'Hands',
          years: ['2012', '2016'],
          exchange_points: '6',
          exchanges_to: ['Mystic Silk', 'Darkwood Plank'],
          sources: ['Standard Pack', 'Exchange']
      }
      expect(token.token_hash).to eql test_hash
    end
  end

end