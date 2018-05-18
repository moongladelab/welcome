pragma solidity ^0.4.23;

import "./Answer.sol";

contract Quiz {
	address public quizMaker;

	uint8 public numberOfOptions;
	mapping (uint8 => Answer) internal answers;

	uint constant MaxOptions = 5;
	uint constant FEE = 989;


	constructor (address _quizMaker) public {
		quizMaker = _quizMaker;
	}

	modifier onlyQuizMaker() {
		require(msg.sender == quizMaker);
		_;
	}

	function changeQuizMaker(address _newQuizMaker) onlyQuizMaker external {
		quizMaker = _newQuizMaker;
	}

	function registerAnswers(address[] _answers) onlyQuizMaker external {
		require(_answers.length == MaxOptions);
		for(uint8 i = 0; i < MaxOptions; i++)
			answers[i] = Answer(_answers[i]);
	}

	function () external payable {
	}

	function openQuiz(uint256 _start, uint256 _end, uint256 _cap, uint8 _options) onlyQuizMaker external {
		require(_options <= MaxOptions);
		uint8 i;
		for(i = 0; i < _options; i++)
			require(answers[i].isOpen() == false);

		for(i = 0; i < _options; i++)
			answers[i].openAnswer(_start, _end, _cap);

		numberOfOptions = _options;
	}

	function closeQuiz(uint8 rightAnswer) onlyQuizMaker external {
		require(rightAnswer < numberOfOptions);
		uint8 j;
		for(j = 0; j < numberOfOptions; j++) {
			answers[j].closeAnswer();
		}

		uint256 W;
		uint256 L;
		uint256 A;

		W = answers[rightAnswer].getGathered();
		for(j = 0; j < numberOfOptions; j++) {
			if(j != rightAnswer)
				A += answers[j].getGathered();
		}


		uint256 i;
		uint256 total = answers[rightAnswer].getTotalPlayers();
		for(i = 0; i < total; i++) {
			A = answers[rightAnswer].getAmount(i);
			answers[rightAnswer].getAddress(i).transfer(prize(A, W, L));
		}

	}

	function prize(uint256 _A, uint256 _W, uint256 _L) internal pure returns(uint256) {
		return ((_W + _L) * _A * FEE / 1000) / _L;
	}

}

