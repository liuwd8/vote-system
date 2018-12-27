pragma solidity ^0.5.0;

contract BallotManager {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    struct Ballot {
        address chairperson;
        mapping(address => Voter) voters;
        Proposal[] proposals;
    }

    mapping(bytes32 => Ballot) ballots;

    bytes32[] ballotTitles;
    
    function getBallotTitiles() public view returns(bytes32[] memory) {
        return ballotTitles;
    }
    function InitiateVote(bytes32 ballotName, bytes32[] memory proposalNames) public {
        address x;
        require(ballots[ballotName].chairperson == x, "The ballot is exit");
        Ballot storage ballot = ballots[ballotName];
        for (uint i = 0; i < proposalNames.length; ++i) {
            ballot.proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
        ballot.chairperson = msg.sender;
        ballotTitles.push(ballotName);
    }
    function addProposal(bytes32 ballotName, bytes32 proposalNames) public {
        Ballot storage ballot = ballots[ballotName];
        address x;
        require(ballots[ballotName].chairperson != x, "The ballot is not exit");
        require(!ballot.voters[msg.sender].voted, "Initiating a proposal requires no voted.");
        bool noPerson = true;
        for (uint i = 0; i < ballot.proposals.length; ++i) {
            if (ballot.proposals[i].name == proposalNames) {
                noPerson = false;
            }
        }
        require(noPerson, "The proposal is already in the list");
        ballot.proposals.push(Proposal({
            name: proposalNames,
            voteCount: 0
        }));
    }

    function getProposals(bytes32 ballotName) public view returns(bytes32[] memory) {
        address x;
        Ballot storage ballot = ballots[ballotName];
        require(ballot.chairperson != x, "The ballot is not exit");
        bytes32[] memory a = new bytes32[](ballot.proposals.length);
        for (uint i = 0; i < ballot.proposals.length; ++i) {
            a[i] = ballot.proposals[i].name;
        }
        return a;
    }
    

    function delegate(bytes32 ballotName, address to) public {
        address x;
        require(ballots[ballotName].chairperson != x, "The ballot is not exit");
        Ballot storage ballot = ballots[ballotName];
        Voter storage sender = ballot.voters[msg.sender];
        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");
        while (ballot.voters[to].delegate != address(0)) {
            to = ballot.voters[to].delegate;
            require(to != msg.sender, "Found loop in delegation.");
        }
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = ballot.voters[to];
        if (delegate_.voted) {
            ballot.proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            if (delegate_.weight == 0) {
                delegate_.weight = 1;
            }
            delegate_.weight++;
        }
    }
    function vote(bytes32 ballotName, uint proposal) public {
        address x;
        require(ballots[ballotName].chairperson != x, "The ballot is not exit");
        Ballot storage ballot = ballots[ballotName];
        Voter storage sender = ballot.voters[msg.sender];
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        if (sender.weight == 0) sender.weight = 1;
        ballot.proposals[proposal].voteCount += sender.weight;
    }
    function winningProposal(bytes32 ballotName) public view
            returns (uint winningProposal_)
    {
        address x;
        require(ballots[ballotName].chairperson != x, "The ballot is not exit");
        Ballot storage ballot = ballots[ballotName];
        uint winningVoteCount = 0;
        for (uint p = 0; p < ballot.proposals.length; p++) {
            if (ballot.proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = ballot.proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
        return winningProposal_;
    }
    function winnerName(bytes32 ballotName) public view
            returns (bytes32 winnerName_)
    {
        address x;
        require(ballots[ballotName].chairperson != x, "The ballot is not exit");
        winnerName_ = ballots[ballotName].proposals[winningProposal(ballotName)].name;
    }
}