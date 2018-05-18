pragma solidity ^0.4.23;

import "./Answer.sol";

contract Quiz {
	address public quizMaker;

	uint8 public numberOfOptions;
	mapping (uint8 => Answer) internal answers;

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
		require(_answers.length == 4);
		for(uint8 i = 0; i < 4; i++)
			answer[i] = Answer(_answers[i]);
	}

	function () external payable {
	}

	function openQuiz(uint256 _start, uint256 _end, uint256 _cap, uint8 _options) onlyQuizMaker external {
		uint8 i;
		for(i = 0; i < _options; i++)
			require(answers[i].opened == false);

		for(uint8 i = 0; i < _options; i++)
			answers[i].openAnswer(_start, _end, _cap);

		numberOfOptions = _options;
	}

	function closeQuiz(uint8 rightAnswer) {
		require(answer <= numberOfOptions && answer != 0)
		uint256 i;
		for(i = 0; i < numberOfOptions; i++) {
			answers[i].closeAnswer();
		}

		uint256 W;
		uint256 L;
		uint256 A;

		W = answer[rightAnswer].gathered;
		for(i = 0; i < numberOfOptions; i++) {
			if(i != rightAnswer)
				A += answer[i].gathered;
		}


		for(i = 0; i < answer[rightAnswer].totalPlayers; i++) {
			A = answer[rightAnswer].getAmount(i);
			answer[rightAnswer].getAddress(i).transfer(prize(A, W, L));
		}

	}

	function prize(uint256 _A, uint256 _W, uint256 _L) internal view returns(uint256) {
		return ((_W + _L) * 0.989 * _A) / _L;
	}

	/*
	function answered(address _participant, uint256 _amount, uint8 _options) {
		require(msg.sender == answers[_options].address);
	}
   */

}

