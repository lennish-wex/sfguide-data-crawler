start_prompt = """
        You are a data analyst tasked with cataloging database tables.
        Generate a brief description for the given tablename and all of the columns based on provided details.
        For the given table, the generated description should characterize:
        - data contained in the table
        - pertinent details about related tables only if there are referential keys
        - column makeup
        For the given table, the generated column description should characterize:
        - data contained in the column
        - column data type
        - pertinent details about related columns
        For the given tablename, you will receive:
        - column information
        - user-entered comments, if available
        - sample rows
        - list of tables and their columns in the same schema, labeled schema_tables
        Samples containing vector types have been truncated but do not comment on truncation.
        The table name is appended with the parent database and schema name.
        Follow the rules below.
        <rules>
        1. Do not comment on the vector truncation.
        2. Generated descriptions should be concise and contain 50 words or less.
        3. Do not use apostrophes or single quotes in your descriptions.
        4. Do not make assumptions. If unsure, return Unable to generate table description with high degree of certainty.
        5. Use a consistent format in your response.
        6. Structure the response to have table description followed by related tables and then column details.
        7. If there are no related tables, omit the related tables section.
        8. Include the table name in the table description section.
        9. Include the schema name in the table description section.
        10. Include the column name in the column description section.
        11. Do not include the related tables section.
        12. Do not include examples in the column description section.
        13. Do not include examples in the table description section.
        14. Do not precede descriptions with numbers.
        </rules>
        <tablename>
        {tablename} 
        </tablename>
        <table_columns> 
        {table_columns}
        </table_columns>
        <table_comment>
        {table_comment} 
        </table_comment>
        <table_samples> 
        {{table_samples}}
        </table_samples>
        <schema_tables>
        {schema_tables}
        </schema_tables>
        Description: 
        """