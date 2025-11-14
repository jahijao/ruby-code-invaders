require 'code_invaders/radar'
require 'code_invaders/concerns/pattern_matcher'

RSpec.describe PatternMatcher do
  let(:test_class) do
    Class.new do
      include PatternMatcher
    end.new
  end

  describe '#pattern_match' do
    context 'when patterns match exactly' do
      let(:pattern) do
        [
          ['o', 'o', 'o'],
          ['o', '-', 'o']
        ]
      end

      let(:subpattern) do
        [
          ['o', 'o', 'o'],
          ['o', '-', 'o']
        ]
      end

      it 'returns 100% match' do
        result = test_class.pattern_match(pattern, subpattern)
        expect(result).to eq(100)
      end
    end

    context 'when patterns partially match' do
      let(:pattern) do
        [
          %w[o o o],
          %w[o o o]
        ]
      end

      let(:subpattern) do
        [
          ['o', 'o', 'o'],
          ['o', '-', 'o']
        ]
      end

      it 'returns correct percentage' do
        result = test_class.pattern_match(pattern, subpattern)
        # 5 out of 6 cells match = 83%
        expect(result).to eq(83)
      end
    end

    context 'when patterns do not match at all' do
      let(:pattern) do
        [
          %w[o o],
          %w[o o]
        ]
      end

      let(:subpattern) do
        [
          ['-', '-'],
          ['-', '-']
        ]
      end

      it 'returns 0% match' do
        result = test_class.pattern_match(pattern, subpattern)
        expect(result).to eq(0)
      end
    end

    context 'when pattern lengths differ' do
      let(:pattern) do
        [
          %w[o o o]
        ]
      end

      let(:subpattern) do
        [
          %w[o o],
          %w[o o]
        ]
      end

      it 'returns 0' do
        result = test_class.pattern_match(pattern, subpattern)
        expect(result).to eq(0)
      end
    end

    context 'with larger patterns' do
      let(:pattern) do
        [
          ['o', '-', 'o', '-', 'o'],
          ['-', 'o', 'o', 'o', '-'],
          ['o', 'o', 'o', 'o', 'o']
        ]
      end

      let(:subpattern) do
        [
          ['o', '-', 'o', '-', 'o'],
          ['-', 'o', 'o', 'o', '-'],
          ['o', 'o', '-', 'o', 'o']
        ]
      end

      it 'calculates percentage correctly' do
        result = test_class.pattern_match(pattern, subpattern)
        # 14 out of 15 cells match = 93%
        expect(result).to eq(93)
      end
    end
  end
end
