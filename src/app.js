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
        const todoList = await $.getJSON('TodoList.json') // extracts out the smart contract json file
            // create a truffle contract
        App.contracts.TodoList = TruffleContract(todoList)
        App.contracts.TodoList.setProvider(App.web3Provider) // gives copy of the contract in js
        console.log(todoList)
        App.todoList = await App.contracts.TodoList.deployed() // deploys the contract  
    },
    render: async() => {
        // this loading stuff is like mutexes 
        // prevents double rendering
        if (App.loading) {
            return
        }
        App.setLoading(true)
        $('#account').html(App.account);
        await App.renderTasks()
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
    renderTasks: async() => {
        // First load the task from the blockchain
        const taskCount = await App.todoList.taskCount()
        const $taskTemplate = $('.taskTemplate')
        for (var i = 1; i <= taskCount; i++) {
            const task = await App.todoList.tasks(i)
            console.log('Task is ', task)
            const ID = task[0].toNumber()
            const CONTENT = task[1]
            const COMPLETED = task[2]

            // create html
            const $newTaskTemplate = $taskTemplate.clone()
            $newTaskTemplate.find('.content').html(CONTENT)
            $newTaskTemplate.find('input')
                .prop('name', ID)
                .prop('id', "checkbox" + ID)
                .prop('checked', COMPLETED)
                .on('change', App.toggleTask)
            if (COMPLETED) {
                $('#completedTaskList').append($newTaskTemplate)
            } else {
                $('#taskList').append($newTaskTemplate)
            }
            $newTaskTemplate.show()
        }
        console.log('All tasks displayed', taskCount.toNumber())
    },
    addTask: async(task_name) => {
        console.log('FUNCTION IS CALLED', task_name, web3.eth.accounts[0], App.todoList)
            // App.setLoading(true)
        await App.todoList.createTask(task_name, {
            from: web3.eth.accounts[0]
        }); // MAKE SOME CHANGE HERE
        // App.setLoading(false)
        console.log('Task added', task_name)
    },
    toggleTask: async(e) => {
        const $checkbox = $(e.target)
        const ID = $checkbox.prop('name')
        const COMPLETED = $checkbox.prop('checked')
        console.log('ID is ', ID, 'COMPLETED is ', COMPLETED)
        await App.todoList.toggleTask(ID, {
            from: web3.eth.accounts[0]
        });
        window.location.reload()
    }
}


$("form").on('submit', async function(event) {
    // ajax call here
    event.preventDefault();
    console.log('AJAX CALL MADE')
    const task_name = event.target.taskname.value
    console.log('Adding task :: ', task_name)
    await App.addTask(task_name.toString());
    console.log('Task added', task_name)
    window.location.reload();
});

function clickedBox() {
    console.log('clicked');
}


$(() => {
    $(window).load(() => {
        App.load();
    })
})