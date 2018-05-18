pragma solidity ^0.4.23;

import "./Answer.sol";

contract Quiz {
	address public quizMaker;

	uint8 public numberOfOptions;
	mapping (uint8 => Answer) internal answers;
	mapping (uint8 => mapping (address => uint256)) participated;

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

	function closeQuiz(uint8 answer) {
		require(answer <= numberOfOptions && answer != 0)
		for(uint8 i = 0; i < numberOfOptions; i++)
			answers[i].closeAnswer();
	}

	function answered(address _participant, uint256 _amount, uint8 _options) {
		require(msg.sender == answers[_options].address);
		participated[_options][_participants] += _amount;
	}

}

