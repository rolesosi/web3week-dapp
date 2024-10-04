//SPDX-License-Identifier: MIT 
pragma solidity 0.8.26;

struct Bet{
    uint amount;
    uint candidate;
    uint timestamp;
    uint claimed;
}
struct Dispute{
    string candidate1;
    string candidate2;
    string image1;
    string image2;
    uint total1;
    uint total2;
    //contabilizar total de apostadores em cada candidato;
    uint totalBet1;
    uint totalBet2;
    uint winner;
    
}

contract BetCandidate{

    Dispute public dispute;
    mapping(address => Bet) public allBets;


    address immutable owner;
    uint constant fee = 100; //%
    uint public netPrize;
    uint commission;
    // não permitir apostar depois de uma data x;
    uint constant betDateLimit = 1730775599; //04/11/2024 23:59:59;
    // somente permitir finalizar depois de uma data x;
    uint constant finishDate  = 1731466799;

    constructor(){
        owner = msg.sender;
        dispute = Dispute({
            candidate1: "D. Trump",
            candidate2: "K. Harris",
            image1: "http://bit.ly/3zmSfiA",
            image2: "http://bit.ly/4gF4mYO",
            total1: 0,
            total2: 0,
            totalBet1: 0,
            totalBet2: 0,
            winner: 0
        });
    }

    function bet(uint candidate) external payable{
        require(candidate == 1 || candidate == 2, "Invalid candidate");
        require(msg.value > 0, "Invalid bet");
        require(dispute.winner == 0, "Dispute closed");
        require(betDateLimit > block.timestamp, "Bet is closed");
        require(allBets[msg.sender].amount == 0 ,"Only one bet per address");

        Bet memory newBet;
        newBet.amount = msg.value;
        newBet.candidate = candidate;
        newBet.timestamp = block.timestamp;
        newBet.claimed = 0;

        allBets[msg.sender] = newBet;

        if(candidate == 1){
            dispute.total1 += msg.value;
            dispute.totalBet1 ++;
        }else{
            dispute.total2 += msg.value;
            dispute.totalBet2 ++;
        }
    }

    function finish(uint winner) external{
        require(msg.sender == owner, "Ivalid account");
        require(winner == 1 || winner == 2,"Invalid candidate");
        require(dispute.winner == 0,"Dispute closed");
        require(finishDate < block.timestamp ,"Wait the time to finish");

        dispute.winner = winner;

        uint grossPrize = dispute.total1 + dispute.total2;
        commission = (grossPrize * fee) / 1e4;
        netPrize = grossPrize - commission;

        //payable(owner).transfer(commission);
    }

    function claim() external payable {
        Bet memory userBet = allBets[msg.sender];
        require(dispute.winner > 0 && dispute.winner == userBet.candidate && userBet.claimed == 0,"Invalid claim");

        uint winnerAmount = dispute.winner == 1 ? dispute.total1 : dispute.total2;
        uint ratio = (userBet.amount * 1e4) / winnerAmount;
        uint individualPrize = netPrize * ratio / 1e4;
        allBets[msg.sender].claimed = individualPrize;
        payable(msg.sender).transfer(individualPrize);
    }

    //não sacar comissão no finish, mas sim em uma função separada;
    function claimComission() external{
        require(msg.sender == owner, "Ivalid account");
        require(dispute.winner != 0,"Dispute open");
        require(block.timestamp < finishDate + 7 days,"Invalid date");

        payable(owner).transfer(commission);
        //payable(owner).transfer(address(this).balance);
    }

    function setImage(uint candidate, string memory image) external{
        require(msg.sender == owner, "Ivalid account");
        require(candidate == 1 || candidate == 2,"Invalid candidate");
        require(bytes(image).length > 0,"Invalid image");
        if(candidate == 1){
            dispute.image1 = image;
        }else{
            dispute.image2 = image;
        }
    }
}

/* 
Desafios:
modifier onlyOwner() { require(msg.sender == owner, "Conta invalida"); _; }
EX: ​​function finish(uint winner) external onlyOwner {}
*/