# Agent Admin Tools
This repository provides a handy (and very barebones) environment to modify the schema of your Agent instance.

The schema of the agent consists of the relatively static parts that support SSI operations, such as templates and personas.

## Setup
1. clone this directory and open it in vscode
2. install v0.14.2 of the "Event Better TOML" vscode extension

## Usage

Write a schema mutation in the ./playground.toml file. Currently schema mutations support creating credential templates and personas. The toml extension should provide toml validation, syntax highlighting and completion based on the `jolocom-agent-schema-toml-v1.json` json schema. This json schema defines the expected structure of a schema mutation.

Update the schema of your agent by executing ./updateSchema. This will apply your schema mutation to the agent, by sending the contents of the ./playground.toml file to the `PATCH /schema` endpoint. The ./updateSchema script can be used as follows

```sh
./updateSchema <BEARER_TOKEN> <AGENT_URL> <SCHEMA_MUTATION_FILE_PATH>
```
* BEARER_TOKEN is required, this the bearer token that can be generated from the `POST /token` request
* AGENT_URL is optional and defaults to localhost:9000
* SCHEMA_MUTATION_FILE_PATH is optional and defaults to ./playground.toml

Alternatively you can make a request to `PATCH /schema` yourself by using your schema mutation as the body of the request. The request must use the header `Content-Type: application/toml`. You can do this using your HTTP client of choice, e.g. the swagger ui, postman, etc.

## Background 
The Agent supports a few ways to mutate its schema, however the set of tools in this repository promotes the use of the latest (and my favourite) approach. This approach utilises schema mutations written in a TOML based DSL. TOML was chosen because it was easy to implement and offers a decent experience, however I the ideal future implementation of this concept would probably be a custom language. 

## What is a schema mutation
A schema mutation is a collection of statements that mutate the state of an Agents "schema". Think SQL `CREATE TABLE` statements but for SSI. Statements are executed in order, so later statements can reference resources created in earlier statemenents. 

Each statement must be proceeded by a ```[[statement]]``` token (in reality this is just toml syntax for adding a entry entry to the "statement" array) 

A statement is for a particular operation, which must be specified. e.g. the following statement is used to create a persona. (in toml land this is adding the create.persona property (which is a table/object) to the statement entry)
```toml
[[statement]]
[statement.create.persona]
```
This statement requires that values for certain properties are provided. The json schema in this repository validates this and is used to provide autocompletion. e.g. for a persona the `name` property is required

```toml
[[statement]]
[statement.create.persona]
name = "MyPersona"
```

Any optional properties can also be provided, e.g. this will create an sdk2 persona

```toml
[[statement]]
[statement.create.persona]
name = "MyPersona"
config.type = "sdk2"
```

# Supported statements
See the 'jolocom-agent-schema-toml-v1.json` for details

**Create Persona**
```toml
[[statement]]
[statement.create.persona]
```

**Create Credential Template**
```toml
[[statement]]
[statement.create.credentialTemplate]
```


