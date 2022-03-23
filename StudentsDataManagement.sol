/*
author: horden.eth
*/
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
    constructor ( address initOwner) public {
    owner = initOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    uint indexcount=0; //拿來當索引值＆mapping的key
    mapping(uint => Student) StudentMap;


    //將值塞入mapping中，塞完一次後indexcount+1
    function inputdata (string id,address Wallet ,string Name,string Phone,string Email ) public onlyOwner{
        StudentMap[indexcount] = Student(id,Wallet,Name ,Phone,Email);
        indexcount++;
    }

    //根據address查詢index
    function getIndexFromAddress(address SearchAddress) public view returns(uint index) {
        for(uint i=0;i<indexcount;i++){
            if(StudentMap[i].walletaddress==SearchAddress){
                return i;
                break;
            }
        }
    }

    //根據學號查詢index
    function getIndexFromID(string SearchID) public view returns(uint index) {
        for(uint i=0;i<indexcount;i++){
            if(keccak256(StudentMap[i].ID)==keccak256(SearchID)){
                return i;
                break;
            }
        }
    }


    //利用index查詢學生所有資料
    function getDataFromIndex(uint index) public view returns(string ShowID,address ShowWallet ,string ShowName,string ShowPhone,string ShowEmail) {
        return (StudentMap[index].ID,StudentMap[index].walletaddress,StudentMap[index].name,StudentMap[index].phone,StudentMap[index].email);
    }


    //利ID查詢學生所有資料 (先叫getIndexFromID取得index再mapping出對應值)
    function getDataFromID(string SearchID) public view returns(string ShowID,address ShowWallet ,string ShowName,string ShowPhone,string ShowEmail) {
        uint index=getIndexFromID(SearchID);
        return (StudentMap[index].ID,StudentMap[index].walletaddress,StudentMap[index].name,StudentMap[index].phone,StudentMap[index].email);
    }

    //根據ID修改address, phone, email (輸入格式： ID, address, phone, email)
    function ModifyDataAccordingToID(string SearchID,address ModifyWallet,string ModifyPhone ,string ModifyEmail) public onlyOwner{
        uint index=getIndexFromID(SearchID);
        StudentMap[index] = Student(SearchID ,ModifyWallet ,StudentMap[index].name ,ModifyPhone ,ModifyEmail);
    }

    //根據ID刪除該學生所以資料，就...全部設成0
    function DeleteDataAccordingToID(string SearchID) public onlyOwner{
        uint index=getIndexFromID(SearchID);
        StudentMap[index] = Student('0' ,0 ,'0' ,'0' ,'0');
    }


}
