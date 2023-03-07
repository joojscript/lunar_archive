fn main() -> Result<(), Box<dyn std::error::Error>> {
    for entry in glob::glob("../prototype/**/*.proto").expect("Failed to read glob pattern") {
        match entry {
            Ok(path) => {
                tonic_build::compile_protos(&path)?;
            }
            Err(e) => println!("{:?}", e),
        }
    }

    Ok(())
}
