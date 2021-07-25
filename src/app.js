App = {
    contracts: {},
    loading: false,
    load: async() => {
        // Load app...
        console.log('App Loading')
        await App.loadWeb3()
        await App.loadAccount()
        await App.loadContract()
        await App.render()
    },

    // sorta like connect to blockchain
    // need metamask extension in
    loadWeb3: async() => {
        if (typeof web3 !== 'undefined') {
            App.web3Provider = web3.currentProvider
            web3 = new Web3(web3.currentProvider)
        } else {
            window.alert("Please connect to Metamask.")
        }
        // Modern dapp browsers...
        if (window.ethereum) {
            window.web3 = new Web3(ethereum)
            try {
                // Request account access if needed
                await ethereum.enable()
                    // Acccounts now exposed
                web3.eth.sendTransaction({ /* ... */ })
            } catch (error) {
                // User denied account access...
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            App.web3Provider = web3.currentProvider
            window.web3 = new Web3(web3.currentProvider)
                // Acccounts always exposed
            web3.eth.sendTransaction({ /* ... */ })
        }
        // Non-dapp browsers...
        else {
            console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
        }

    },
    loadAccount: async() => {
        App.account = web3.eth.accounts[0]
        console.log(App.account)
        web3.eth.defaultAcoount = web3.eth.accounts[0]
    },
    loadContract: async() => {
        const escrow = await $.getJSON('Escrow.json') // extracts out the smart contract json file
            // create a truffle contract
        App.contracts.Escrow = TruffleContract(escrow)
        App.contracts.Escrow.setProvider(App.web3Provider) // gives copy of the contract in js
        console.log(escrow)
        App.escrow_contract = await App.contracts.Escrow.deployed() // deploys the contract  
    },
    render: async() => {
        // this loading stuff is like mutexes 
        // prevents double rendering
        if (App.loading) {
            return
        }
        App.setLoading(true)
        const max = (a, b) => { return a > b ? a : b };
        $('#account').html(App.account.toString().substr(0, ($(window).width() * 2) / 138) + '...');
        const stat = await App.escrow_contract.getStatus()
        if (stat == "Open") {
            $('.status').html('OPEN');
            $('.statusInfo').html('This round is open for participation currently');
        }
        if (stat == "Closed") {
            $('.status').html('CLOSED');
            $('.statusInfo').html('This round is Closed for participation. Awaiting Draw.');
        }
        if (stat == "Completed") {
            $('.status').html('COMPLETED');
            $('.statusInfo').html('This round is Completed. Awaiting Results.');
        }
        await App.renderData();
        App.setLoading(false)


    },
    setLoading: (boolean) => {
        App.loading = boolean
        const loader = $('#loader')
        const content = $('#content')
        if (boolean) {
            loader.show()
            content.hide()
        } else {
            loader.hide()
            content.show()
        }
    },
    renderData: async() => {
        // First load the task from the blockchain
        web3.eth.getBalance(web3.eth.accounts[0], (err, res) => {
            if (err) {
                console.log('ERROR in fetching account details : ', err);
            } else {
                $("#balance").html(web3.fromWei(res, "ether") + " ETH");
            }

        })
        console.log('Entered renderData')
        const current_bid = (await App.escrow_contract.getPrice()).toNumber();
        const tam = (await App.escrow_contract.ticket_amount()).toNumber();
        console.log('Cost is : ', current_bid)
        $("#cost").html(current_bid)
        const $participantTemplate = $('.participantTemplate');
        for (let x = 1; x <= tam; x++) {
            const name = (await App.escrow_contract.getData(x)).toString();
            const $newParticipant = $participantTemplate.clone();
            $newParticipant.find('.content').html(name);
            // make something here
            $('#participantList').append($newParticipant);
            console.log('Name of participant is : ', name);
            $newParticipant.show()
        }
        console.log('Donezo');
    },
    addBid: async() => {
        App.escrow_contract.pay({
            from: web3.eth.accounts[0],
            value: web3.toWei(2, 'ether'),
        });
    },
    transferFund: async() => {
        await App.escrow_contract.transferFunds({
            from: web3.eth.accounts[0]
        });
        console.log('Funds transferred');
    },
    closeLottery: async() => {
        await App.escrow_contract.close({ from: web3.eth.accounts[0] });
    }

}


$("form").on('submit', async function(event) {
    // ajax call here
    event.preventDefault();
    alert(event.target.id);
    console.log('Adding bid');
    if (event.target.id == 'add')
        App.addBid();
    else if (event.target.id == 'roll') {
        App.transferFund();
    } else if (event.target.id == 'close') {
        App.closeLottery();
    }
    // to check fund transfers
    // App.transferFund();
    // window.location.reload();
});



function clickedBox() {
    console.log('clicked');
}


$(() => {
    $(window).load(() => {
        App.load();
    })
})