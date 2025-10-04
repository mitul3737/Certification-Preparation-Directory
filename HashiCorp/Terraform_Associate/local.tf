resource "local_file" "pet"{
    filename= "pets.txt"
    content= "We love cat"
    file_permission = "0700"
}