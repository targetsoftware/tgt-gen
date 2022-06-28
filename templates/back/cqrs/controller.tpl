using Common.Api;
using Common.Core;
using Microsoft.AspNetCore.Mvc;
using <#context_name_space#>.<#context_module#>.Application.Commands;
using <#context_name_space#>.<#context_module#>.Application.Queries;
using <#context_name_space#>.<#context_module#>.Dto.Query;

namespace <#context_name_space#>.<#context_module#>.Api.Controllers
{
    [Route("api/[controller]")]
    public class <#table_name#>Controller : ApiController
    {
        private readonly IMediatorHandler _mediator;

        public <#table_name#>Controller(IMediatorHandler mediator)
        {
            _mediator = mediator;
        }

        [HttpGet]
        [ProducesResponseType(typeof(QueryListResult<<#table_name#>QueryResultDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> Get([FromQuery] <#table_name#>Query request)
        {
            return QueryResponse(await _mediator.Send(request));
        }

        [HttpPost]
        [ProducesResponseType(typeof(CommandResult<Guid>), StatusCodes.Status200OK)]
        public async Task<IActionResult> Post([FromBody] <#table_name#>Command request)
        {
            return CommandResponse(await _mediator.Send(request));
        }
    }
}
