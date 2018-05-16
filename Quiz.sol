pragma solidity ^0.4.23;

import "./Answer.sol";

contract Quiz {
	address public quizMaker;

	Answer public answerYes;
	Answer public answerNo;

	

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

	function regiseterAnswers(address _yes, address _no) onlyQuizMaker external {
		answerYes = Answer(_yes);
		answerNo = Answer(_no);
	}

	function () external payable {
	}

	function openQuiz(uint256 _start, uint256 _end, uint256 _cap) onlyQuizMaker external {
		require(answerYes.opened == false && answerNo.opened == false);

		answerYes.openAnswer(_start, _end, _cap);
		answerNo.openAnswer(_start, _end, _cap);
	}

}

