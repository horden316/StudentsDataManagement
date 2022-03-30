/*
author: horden.eth
*/

//SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.8.13;
contract extrawork1{

    struct  Student {
        string ID;
        address walletaddress;
        string name;
        string phone;
        string email;
    }

    address owner;
    constructor ( address initOwner) {//在初始時指定owner
    owner = initOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier onlyMe(address MyAddress) {//判斷目前執行人
        require(msg.sender == MyAddress, "Permission denied");
        _;
    }




    uint indexcount=0; //拿來當索引值＆mapping的key&拿來看資料筆數
    mapping(uint => Student) StudentMap;

    //有點像把mapping當陣列用
    //將值塞入mapping中，塞完一次後indexcount+1
    function inputdata (string memory id,address Wallet ,string memory Name,string memory Phone,string memory Email ) public onlyOwner{
        bool b=false;
        for(uint i=0;i<indexcount;i++){
            if(keccak256(abi.encodePacked(StudentMap[i].ID))==keccak256(abi.encodePacked(id))){
                b=true;
            }
        }
        require(b==false,"duplicate data");
        StudentMap[indexcount] = Student(id,Wallet,Name ,Phone,Email);
        indexcount++;
    }

    //根據address查詢index
    function getIndexFromAddress(address SearchAddress) public view returns(uint index) {
        require(SearchAddress!=address(0),"Invalid address");
        for(uint i=0;i<indexcount;i++){
            if(StudentMap[i].walletaddress==SearchAddress){
                return i;
            }
        }
    }

    //根據學號查詢index
    function getIndexFromID(string memory SearchID) public view returns(uint index) {
        for(uint i=0;i<indexcount;i++){
            if(keccak256(abi.encodePacked(StudentMap[i].ID))==keccak256(abi.encodePacked(SearchID))){
                return i;
            }
        }
        revert("No ID in database");//如果跑完一圈都沒有那就revert沒有這ID
    }

    //根據ID查詢address
    function getAddressFromID(string memory SearchID) public view returns(address MyAddre) {
        return StudentMap[getIndexFromID(SearchID)].walletaddress;
    }

    //利用index查詢學生所有資料
    function getDataFromIndex(uint index) public view returns(string memory ShowID,address ShowWallet ,string memory ShowName,string memory ShowPhone,string memory ShowEmail) {
        return (StudentMap[index].ID,StudentMap[index].walletaddress,StudentMap[index].name,StudentMap[index].phone,StudentMap[index].email);
    }


    //利ID查詢學生所有資料 (先叫getIndexFromID取得index再mapping出對應值)
    function getDataFromID(string memory SearchID) public view returns(string memory ShowID,address ShowWallet ,string memory ShowName,string memory ShowPhone,string memory ShowEmail) {
        uint index=getIndexFromID(SearchID);
        return (StudentMap[index].ID,StudentMap[index].walletaddress,StudentMap[index].name,StudentMap[index].phone,StudentMap[index].email);
    }

    //根據ID修改address, phone, email (輸入格式： ID, address, phone, email)
    function ModifyDataAccordingToID(string memory SearchID,address ModifyWallet,string memory ModifyPhone ,string memory ModifyEmail) public onlyOwner{
        uint index=getIndexFromID(SearchID);
        StudentMap[index] = Student(SearchID ,ModifyWallet ,StudentMap[index].name ,ModifyPhone ,ModifyEmail);
    }

    //根據ID刪除該學生所以資料，就...全部設成0
    function DeleteDataAccordingToID(string memory SearchID) public onlyOwner{
        uint index=getIndexFromID(SearchID);
        delete StudentMap[index] ;
        for(uint i=index;i<indexcount;i++){
            StudentMap[i]=StudentMap[i+1];
        }
        delete StudentMap[indexcount] ;
        indexcount--;
    }

    //只有自己能根據ID修改address, phone, email (輸入格式： ID, address, phone, email)
    function ModifyDataOnlyMe(string memory SearchID,address ModifyWallet,string memory ModifyPhone ,string memory ModifyEmail) public onlyMe(getAddressFromID(SearchID)){
        uint index=getIndexFromID(SearchID);
        StudentMap[index] = Student(SearchID ,ModifyWallet ,StudentMap[index].name ,ModifyPhone ,ModifyEmail);
    }

    function GetQuantity()public view returns(uint num){
        return indexcount;
    }


}
