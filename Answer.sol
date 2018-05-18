pragma solidity ^0.4.23;

import "./Quiz.sol";

contract Answer {
	address public quizMaker;
	Quiz quiz;

	uint256 public gathered;
	uint256 public cap;

	uint256 public startTime;
	uint256 public endTime;

	bool public opened;

	mapping (address => uint256) public playedAmount;
	mapping (uint256 => address) public players;

	uint256 totalPlayers;


	constructor (address _quizMaker, address _quiz) public {
		quizMaker = _quizMaker;
		quiz = Quiz(_quiz);

		opened = false;
	}

	modifier fromQuizMaker() {
		require(msg.sender == quizMaker);
	}
	modifier fromQuizContract() {
		require(msg.sender == quiz.address);
		_;
	}

	function changeQuizMaker(address _newQuizMaker) fromQuizMaker external {
		quizMaker = _newQuizMaker;
	}

	function registerQuiz(address _quiz) fromQuizMaker external {
		quiz = Quiz(_quiz);
	}

	function openAnswer(uint256 _start, uint256 _end, uint _cap) fromQuizContract external {
		require(!opened);

		startTime = _start;
		endTime = _end;
		cap = _cap;

		opened = true;
		gathered = 0;

		for(uint256 i = 0; i < totalPlayers; i++) {
			playedAmount[players[i]] = 0;
		}

		totalPlayers = 0;
	}

	function closeAnswer() fromQuizContract external returns (bool){
		if(!opened)
			return false;

		quiz.address.transfer(gathered);

		opened = false;
	}

	function () external payable {
		require(startTime <= now && now <= endTime);
		if(playedAmount[msg.sender] == 0) {
			players[totalPlayers] = msg.sender;
			totalPlayers++;
		}
		playedAmount[msg.sender] += msg.value;
		gathered += msg.value;
	}
	
	function getAddress(uint256 _no) external view returns(address) {
		return players[_no];
	}

	function getAmount(uint256 _no) external view returns(uint256) {
		return playedAmount[players[_no]];
	}

}

