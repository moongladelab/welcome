pragma solidity ^0.4.23;

import "./Quiz.sol";

contract Answer {
	address public quizMaker;
	address public quizAddress;
	Quiz quiz;

	uint256 public gathered;
	uint256 public cap;

	uint256 public startTime;
	uint256 public endTime;

	bool public opened;


	constructor (address _quizMaker) public {
		quizMaker = _quizMaker;
		opened = false;
	}

	modifier onlyQuizMaker() {
		require(msg.sender == quizMaker);
		_;
	}

	function changeQuizMaker(address _newQuizMaker) onlyQuizMaker external {
		quizMaker = _newQuizMaker;
	}

	function registerQuiz(address _quiz) onlyQuizMaker external {
		quizAddress = _quiz;
		quiz = Quiz(_quiz);
	}

	function openAnswer(uint256 _start, uint256 _end, uint _cap) onlyQuizMaker external {
		require(!opened);

		startTime = _start;
		endTime = _end;
		cap = _cap;

		opened = true;
		gathered = 0;
	}

	function closeAnswer() onlyQuizMaker external {
		require(opened);

		quiz.transfer(gathered);

		opened = false;
	}

	function () external payable {
		require(startTime <= now && now <= endTime);
		gathered += msg.value;

		quiz.answeredYes(msg.sender, msg.value);
		//quiz.answeredNo(msg.sender, msg.value);
	}


}

