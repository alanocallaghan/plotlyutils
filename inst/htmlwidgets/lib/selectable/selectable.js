function capitalise(string) {
    return(string[0].toUpperCase() + string.substring(1));
}

function onlyUnique(value, index, self) {
    return self.indexOf(value) === index;
}
